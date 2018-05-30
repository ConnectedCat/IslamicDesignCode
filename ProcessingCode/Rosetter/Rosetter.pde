PVector centerPoint, circumPoint;

int WIDTH = 1000;
int HEIGHT = 1000;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;
float dotDiameter = 5;

int numberOfRadiusPoints = 8;
float angleInRads = TWO_PI/numberOfRadiusPoints;

PVector[] circumPoints = new PVector[numberOfRadiusPoints];

void settings(){
  size(WIDTH, HEIGHT);
}

void setup(){
  centerPoint = new PVector(width/2, height/2);
  noFill();
  stroke(255, 255, 0);
  ellipse(centerPoint.x, centerPoint.y, circleDiameter, circleDiameter);
  
  for(int i = 0; i < numberOfRadiusPoints; i++){
    float pointX = centerPoint.x + cos(angleInRads*i)*circleRadius;
    float pointY = centerPoint.y + sin(angleInRads*i)*circleRadius;
    
    noFill();
    stroke(255, 255, 0);
    
    ellipse(pointX, pointY, circleDiameter, circleDiameter);
    circumPoints[i] = new PVector(pointX, pointY);
    
    fill(255, 0, 0);
    noStroke();
  
    int halfPoint = numberOfRadiusPoints/2;

    float startAngle = -angleInRads*(numberOfRadiusPoints-halfPoint-i);
    float stopAngle = -angleInRads*(numberOfRadiusPoints-halfPoint-i)+angleInRads;
    
    arc(circumPoints[i].x, circumPoints[i].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    
    if(numberOfRadiusPoints % 2 == 0){
      startAngle = -angleInRads*(numberOfRadiusPoints-halfPoint+1-i);
      stopAngle = -angleInRads*(numberOfRadiusPoints-halfPoint+1-i)+angleInRads;
      arc(circumPoints[i].x, circumPoints[i].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    }
  }
}
