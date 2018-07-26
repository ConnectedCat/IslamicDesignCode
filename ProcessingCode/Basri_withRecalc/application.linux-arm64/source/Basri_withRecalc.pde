import processing.io.*;
MCP3008 adc;

float[] pots = new float[8];
float tolerance = 0.01;

ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 800;
int HEIGHT = 600;

float circleDiameter = 200;
float minDiameter;
float maxDiameter = 250;
float circleRadius = circleDiameter/2;

int minNumRadPoints = 4;
int maxNumRadPoints = 12;
int numberOfRadiusPoints = 4;

int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

color mainColor, backgroundColor;

void settings() {
  size(WIDTH, HEIGHT);
  adc = new MCP3008(SPI.list()[0]);
}

void setup() {
  colorMode(HSB, TWO_PI, 100, 100, 100);  
  calcTheLevels();
}

void draw() {
  PVector[] currentLevel = levels.get(levels.size() - 1);
  
  readPotValues();
  
  mainColor = color(TWO_PI*pots[2], 100*pots[1], 100*pots[0]);
  backgroundColor = color(TWO_PI*pots[6], 100*pots[7], map(pots[0], 1, 0, 0, 100), 100*pots[5]);
  
  noStroke();
  fill(backgroundColor);
  rect(0, 0, width, height);
  
  circleDiameter = map(pots[4], 0, 1, minDiameter, maxDiameter);
  
  for (int j = 0; j < currentLevel.length; j++) {
    // draw the circles
    stroke(mainColor);
    noFill();
    ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);

    //draw the arches
    fill(mainColor);
    noStroke();

    int halfPoint = numberOfRadiusPoints/2;
    float startAngle, stopAngle;
    if (numberOfRadiusPoints % 2 == 0) { //for even number of points

      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j)+angleInRadians;

      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);

      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;
      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    } 
    else {
      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;

      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    }
  }// for all elements on this level
}//end of draw


//
//
// ALL THE FUNCTIONS USED
//
//

void calcTheLevels() {
  levels.clear();
  for (int i = 0; i <= numberOfLevels; i++) {
    levels.add(new PVector[ int(pow(numberOfRadiusPoints, i)) ]);
  }

  for (int i = 0; i <= numberOfLevels; i++) {
    PVector[] currentLevel = levels.get(i);
    PVector[] previousLevel = (i != 0) ? levels.get(i-1) : new PVector[0];

    for (int j = 0; j < currentLevel.length; j++) {
      if (i != 0) {
        centerPoint = previousLevel[floor(j/numberOfRadiusPoints)];
        float pointX = centerPoint.x + cos(angleInRadians*j)*circleRadius;
        float pointY = centerPoint.y + sin(angleInRadians*j)*circleRadius;
        currentLevel[j] = new PVector(pointX, pointY);
      } else {
        currentLevel[j] = new PVector(width/2, height/2);
      }
    }
  }
  
  // calc min and max diamater
  PVector zeroPoint = new PVector(centerPoint.x+(cos(0)*circleRadius), centerPoint.y+(sin(0)*circleRadius));
  PVector anglePoint = new PVector(centerPoint.x+(cos(angleInRadians)*circleRadius), centerPoint.y+(sin(angleInRadians)*circleRadius));
  
  float archHeight = circleRadius - (cos(angleInRadians/2)*circleRadius);
  
  minDiameter = PVector.dist(zeroPoint, anglePoint) + (archHeight);
}

void readPotValues() {
  for (int i = 0; i < pots.length; i++) {
    float potVal = adc.getAnalog(i);

    if (i==3 ) {
      if (abs(potVal - pots[3]) > (float)1/(maxNumRadPoints-minNumRadPoints)) {
        pots[3] = potVal;
        numberOfRadiusPoints = round(map(pots[3], 1, 0, minNumRadPoints, maxNumRadPoints));
        angleInRadians = TWO_PI/numberOfRadiusPoints;
        thread("calcTheLevels");
      }
    } else {
      if (abs(potVal - pots[i]) > tolerance ) {
        pots[i] = potVal;
      }
    }
  }
}
