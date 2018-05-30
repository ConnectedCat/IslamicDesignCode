ArrayList<PVector> gridPoints = new ArrayList<PVector>();

PVector centerPoint;

float circleRadius = 200;
float dotRadius = 5;
int numberOfRadiusPoints = 6;

//int numberOfLevels = ceil(500/circleRadius);
int numberOfLevels = 2;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

void setup(){
  size(1000, 1000);
  
  centerPoint = new PVector(width/2, height/2);
  
  for(int i = 0; i <= numberOfLevels; i++){
    // we're incrementing levels here, strting with level 0 at the center
    // level 1 would be the first circle radius
    int blue = 0;
    int green = 255;
    if(numberOfLevels % 2 == 0 ){
      blue = 255;
      green = 0;
    }
    color levelColor = color(255/numberOfLevels*i, green, blue);
    //for(int j = 0; j < pow(numberOfRadiusPoints, i); j++){
    for(int j = 0; j < numberOfRadiusPoints; j++){
      // 6 to the power of 0 is 1 - the center point is not required
      // 6 to the power of 1 is 6 - the center point is the center if the 1st
      // 6 to the power of 2 is 36 - the center points are the first 6
      PVector center;
      int centerIndex = floor(j/numberOfRadiusPoints);
      if(i > 0){
        //int centerIndex = i-1;
        
        center = gridPoints.get(centerIndex);
      }
      else {
        center = centerPoint;
      }
      
      float pointX = center.x + (cos(angleInRadians*j) * circleRadius/2*i);
      float pointY = center.y + (sin(angleInRadians*j) * circleRadius/2*i);
      PVector newPoint = new PVector( pointX, pointY );
      
      noStroke();
      fill(levelColor);
      ellipse(newPoint.x, newPoint.y, dotRadius, dotRadius);
      
      text(gridPoints.size() + " c ind " + centerIndex, newPoint.x, newPoint.y + 10*i);
  
      stroke(255);
      noFill();
      ellipse(newPoint.x, newPoint.y, circleRadius, circleRadius);
      
      if(!gridPoints.contains(newPoint)){
        gridPoints.add(newPoint);
      }
    }
  }
  fill(0);
  text("Number of Levels: " + numberOfLevels, 10, height - 30);
  text("Number of gridPoints: " + gridPoints.size(), 10, height - 10);
  
}
