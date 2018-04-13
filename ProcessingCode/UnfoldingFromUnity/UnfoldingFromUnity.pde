ArrayList<PVector> gridPoints = new ArrayList<PVector>();

PVector centerPoint;

float circleRadius = 150;
float dotRadius = 5;
int numberOfRadiusPoints = 6;

int numberOfLevels = ceil(500/circleRadius);
//int numberOfLevels = 2;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

void setup(){
  size(500, 500);
  
  centerPoint = new PVector(width/2, height/2);
  
  for(int i = 0; i <= numberOfLevels; i++){
    // we're incrementing levels here, strting with level 0 at the center
    // level 1 would be the first circle radius
    for(int j = 0; j < pow(numberOfRadiusPoints, i); j++){
      // 6 to the power of 0 is 1 - the center point is not required
      // 6 to the power of 1 is 6 - the center point is the center if the 1st
      // 6 to the power of 2 is 36 - the center points are the first 6
      PVector center;
      if(i > 0){
        //int centerIndex = i-1;
        int centerIndex = floor(j/numberOfRadiusPoints);
        center = gridPoints.get(centerIndex);
      }
      else {
        center = centerPoint;
      }
      
      float pointX = center.x + (cos(angleInRadians*j) * circleRadius/2*i);
      float pointY = center.y + (sin(angleInRadians*j) * circleRadius/2*i);
      PVector newPoint = new PVector( pointX, pointY );
      
      if(!gridPoints.contains(newPoint)){
        gridPoints.add(newPoint);
      }
    }
  }
  
}

void draw(){
  background(125);
  
  //noStroke();
  //fill(255, 0, 0);
  //ellipse(centerPoint.x, centerPoint.y, dotRadius, dotRadius);
  
  //stroke(255);
  //noFill();
  //ellipse(centerPoint.x, centerPoint.y, circleRadius, circleRadius);
  
  for(int i = 0; i < gridPoints.size(); i++){
    PVector currentPoint = gridPoints.get(i);
    noStroke();
    fill(255, 0, 0);
    ellipse(currentPoint.x, currentPoint.y, dotRadius, dotRadius);

    stroke(255);
    
    noFill();
    ellipse(currentPoint.x, currentPoint.y, circleRadius, circleRadius);
  }
  
  fill(0);
  text("Number of Levels: " + numberOfLevels, 10, height - 30);
  text("Number of gridPoints: " + gridPoints.size(), 10, height - 10);
  
}
