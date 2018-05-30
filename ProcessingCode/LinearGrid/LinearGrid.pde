ArrayList<PVector> gridPoints = new ArrayList<PVector>();

PVector centerPoint;

float circleDiameter = 183;
float circleRadius = circleDiameter/2;
float dotRadius = 5;
int numberOfRadiusPoints = 7;

int gridSections = ceil(500/circleRadius) + 2;

float angleInRadians = TWO_PI/numberOfRadiusPoints;

void setup(){
  size(500, 500);
  
  centerPoint = new PVector(width/2, height/2);
  float colInterval = cos(angleInRadians)+circleRadius;
  float startPointX = width/2 - gridSections/2*colInterval;
  
  float rowInterval = sin(angleInRadians)*circleRadius;
  float startPointY = height/2 - gridSections/2 * rowInterval;
  
  for(int i = 0; i < gridSections; i++){
    for(int j = 0; j < gridSections; j++){
      float xPos = startPointX+colInterval*j;
      if (i%2 != 0) { // even number row
        xPos = startPointX+colInterval*j + circleRadius/2;
      }
      noStroke();
      fill(255, 0, 0);
      ellipse(xPos, startPointY + rowInterval*i, dotRadius, dotRadius);
      
      stroke(255);
      noFill();
      ellipse(xPos, startPointY + rowInterval*i, circleDiameter, circleDiameter); 
    }
  }
  
  fill(0);
  text("Starting Point: " + startPointX + ", " + startPointY, 10, height - 30);
  text("Sections: " + gridSections, 10, height - 10);
}
