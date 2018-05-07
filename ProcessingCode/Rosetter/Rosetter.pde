PVector centerPoint, circumPoint;



int WIDTH = 1000;
int HEIGHT = 1000;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;
float dotDiameter = 5;

int numberOfRadiusPoints = 6;
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
    
    ellipse(pointX, pointY, circleDiameter, circleDiameter);
    circumPoints[i] = new PVector(pointX, pointY);
  }
  
  fill(255, 0, 0);
  noStroke();
  
  
  ellipse(centerPoint.x, centerPoint.y, dotDiameter, dotDiameter);
  
  for(int i = 0; i < numberOfRadiusPoints; i++){
    //ellipse(circumPoints[i].x, circumPoints[i].y, dotDiameter, dotDiameter);
    arc(circumPoints[i].x, circumPoints[i].y, circleDiameter, circleDiameter, -angleInRads*(numberOfRadiusPoints-3-i), -angleInRads*(numberOfRadiusPoints-3-i)+angleInRads, CHORD);
    arc(circumPoints[i].x, circumPoints[i].y, circleDiameter, circleDiameter, -angleInRads*(numberOfRadiusPoints-2-i), -angleInRads*(numberOfRadiusPoints-2-i)+angleInRads, CHORD);
  }
}
