import processing.io.*;
MCP3008 adc;

float[] pots = new float[8];
float tolerance = 0.01;

ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 1000;
int HEIGHT = 1000;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;

int minNumRadPoints = 4;
int maxNumRadPoints = 12;
int numberOfRadiusPoints = 4;

int totalPoints = 0;
int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

color bFrom = color(255, 255, 0);
color bTo = color(0, 255, 255);

color mainColor, backgroundColor;



void settings(){
  size(WIDTH, HEIGHT);
  adc = new MCP3008(SPI.list()[0]);
}

void setup(){
  colorMode(HSB, 255);  
  calcTheLevels();
}

void draw(){
  readPotValues();
  
  background(lerpColor(bFrom, bTo, pots[0]));

  for(int i = 0; i <= numberOfLevels; i++){
    if(i == levels.size() - 1){
      PVector[] currentLevel = levels.get(i);
      
      for(int j = 0; j < currentLevel.length; j++){
        //update diameter
        circleDiameter = map(pots[4], 0, 1, 50, 250);
        
        // set the color
        println(pots[3]);
        mainColor = color(255*pots[3], 255*pots[2], 255*pots[1]);
        
        // draw the circles
        stroke(mainColor);
        noFill();
        ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);
        
        //draw the arches
        fill(mainColor);
        noStroke();
        
        int halfPoint = numberOfRadiusPoints/2;
        float startAngle, stopAngle;
        if(numberOfRadiusPoints % 2 == 0){ //for even number of points
          
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
    }// it it's the last level
  }//go through all levels
}//end of draw


//
//
// ALL THE FUNCTIONS USED
//
//

void calcTheLevels(){
  totalPoints = 0;
  levels.clear();
  for(int i = 0; i <= numberOfLevels; i++){
    levels.add(new PVector[ int(pow(numberOfRadiusPoints, i)) ]);
  }
  
  for(int i = 0; i <= numberOfLevels; i++){
    PVector[] currentLevel = levels.get(i);
    PVector[] previousLevel = (i != 0) ? levels.get(i-1) : new PVector[0];
    
    for(int j = 0; j < currentLevel.length; j++){
      if(i != 0){
        centerPoint = previousLevel[floor(j/numberOfRadiusPoints)];
        float pointX = centerPoint.x + cos(angleInRadians*j)*circleRadius;
        float pointY = centerPoint.y + sin(angleInRadians*j)*circleRadius;
        currentLevel[j] = new PVector(pointX, pointY);
      }
      else{
        currentLevel[j] = new PVector(width/2, height/2);
      }
      totalPoints++;
    }
  }
}

void readPotValues(){
  for(int i = 0; i < pots.length; i++){
    float potVal = adc.getAnalog(i);

    if(i==5 ){
      if(abs(potVal - pots[5]) > (float)1/(maxNumRadPoints-minNumRadPoints)){
        pots[5] = potVal;
        numberOfRadiusPoints = round(map(pots[5],1,0,minNumRadPoints,maxNumRadPoints));
        angleInRadians = TWO_PI/numberOfRadiusPoints;
        calcTheLevels();
      }
    }
    else{
      if(abs(potVal - pots[i]) > tolerance ){
        pots[i] = potVal;
      }
    }
  }
}
