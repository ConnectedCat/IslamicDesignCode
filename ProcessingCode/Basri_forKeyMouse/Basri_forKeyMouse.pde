float[] pots = new float[8];
/*
* POTs Values are as follows:
* 0. Main color / Backgound color brightness
* 1. Main color saturation
* 2. Main color hue
* 3. Number of point on the circle
* 4. Circle Diameter
* 5. Backgound color opacity
* 6. Backgound color hue
* 7. Backgound color saturation
*
*/
float increment = 0.05;

ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 800;
int HEIGHT = 600;

float circleDiameter = 200;
float minDiameter;
float maxDiameter = 250;
float circleRadius = circleDiameter/2;

int minNumRadPoints = 4;
int maxNumRadPoints = 9;
int numberOfRadiusPoints = 4;

int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

color mainColor, backgroundColor;

void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  colorMode(HSB, TWO_PI, 100, 100, 100);
  
  pots[0] = 0.5;
  pots[1] = 0.5;
  pots[2] = 0.5;
  pots[3] = 0.5;
  pots[4] = 0.5;
  pots[5] = 0.5;
  pots[6] = 0.5;
  pots[7] = 0.5;
  
  calcTheLevels();
}

void draw() {
  PVector[] currentLevel = levels.get(levels.size() - 1);
  
  mainColor = color(TWO_PI*pots[2], 100*pots[1], 100*pots[0]);
  backgroundColor = color(TWO_PI*pots[6], 100*pots[7], map(pots[0], 1, 0, 0, 100), map(pots[5], 0, 1, 30, 100));
  
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

void keyReleased(){
  switch(key){
    case 'q':
      if(pots[0] < 1) pots[0] = pots[0]+increment;
      break;
    case 'a':
      if(pots[0] > 0) pots[0] = pots[0]-increment;
      break;
    case 'w':
      if(pots[1] < 1) pots[1] = pots[1]+increment;
      break;
    case 's':
      if(pots[1] > 0) pots[1] = pots[1]-increment;
      break;
    case 'e':
      if(pots[2] < 1) pots[2] = pots[2]+increment;
      break;
    case 'd':
      if(pots[2] > 0) pots[2] = pots[2]-increment;
      break;
    case 'r':
      if(pots[3] < 1) pots[3] = pots[3]+increment;
      numberOfRadiusPoints = round(map(pots[3], 1, 0, minNumRadPoints, maxNumRadPoints));
      angleInRadians = TWO_PI/numberOfRadiusPoints;
      thread("calcTheLevels");
      break;
    case 'f':
      if(pots[3] > 0) pots[3] = pots[3]-increment;
      numberOfRadiusPoints = round(map(pots[3], 1, 0, minNumRadPoints, maxNumRadPoints));
      angleInRadians = TWO_PI/numberOfRadiusPoints;
      thread("calcTheLevels");
      break;
    case 't':
      if(pots[4] < 1) pots[4] = pots[4]+increment;
      break;
    case 'g':
      if(pots[4] > 0) pots[4] = pots[4]-increment;
      break;
    case 'y':
      if(pots[5] < 1) pots[5] = pots[5]+increment;
      break;
    case 'h':
      if(pots[5] > 0) pots[5] = pots[5]-increment;
      break;
    case 'u':
      if(pots[6] < 1) pots[6] = pots[6]+increment;
      break;
    case 'j':
      if(pots[6] > 0) pots[6] = pots[6]-increment;
      break;
    case 'i':
      if(pots[7] < 1) pots[7] = pots[7]+increment;
      break;
    case 'k':
      if(pots[7] > 0) pots[7] = pots[7]-increment;
      break;
  }
}
