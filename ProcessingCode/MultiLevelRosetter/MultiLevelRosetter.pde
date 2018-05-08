import processing.io.*;
MCP3008 adc;

float[] pots = new float[4];
float[] prevPots = new float[4];

float tolerance = 0.03;

ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 500;
int HEIGHT = 500;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;
float dotRadius = 5;
int numberOfRadiusPoints = 7;

int totalPoints = 0;
int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

color from = color(255, 0, 0);
color to = color(0, 0, 255);

color mainColor, backgroundColor;

void settings(){
  size(WIDTH, HEIGHT);
  adc = new MCP3008(SPI.list()[0]);
}

void setup(){
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

void draw(){
  println("Frame rate: " + frameRate);
  background(lerpColor(from, to, prevPots[3]));
  
  for(int i = 0; i < pots.length; i++){
    pots[i] = adc.getAnalog(i);
    
    println(pots[i]);
    
    if(abs(pots[i] - prevPots[i]) > tolerance ){
      prevPots[i] = pots[i];
    }
  }
  
  for(int i = 0; i <= numberOfLevels; i++){
    if(i == levels.size() - 1){
      PVector[] currentLevel = levels.get(i);
      
      for(int j = 0; j < currentLevel.length; j++){
        circleDiameter = map(prevPots[0], 0, 1, 50, 250);
        
        mainColor = color(255*prevPots[3], 255*prevPots[2], 255*prevPots[1]);
        
        stroke(mainColor);
        noFill();
        ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);
        fill(mainColor);
        noStroke();
        
        int halfPoint = numberOfRadiusPoints/2;
        if(numberOfRadiusPoints % 2 == 0){
          
          float startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j);
          float stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j)+angleInRadians;
      
          arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
          
          startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
          stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;
          arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
        }
        else {
          float startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
          float stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;
      
          arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
        }
        
      }// for all elements on this level
    }// it it's the last level
  }//go through all levels
}
