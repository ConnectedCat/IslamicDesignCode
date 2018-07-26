ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 1000;
int HEIGHT = 1000;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;
float dotRadius = 5;
int numberOfRadiusPoints = 5;

int totalPoints = 0;

//int numberOfLevels = ceil(WIDTH/circleDiameter); // size of the longest dimention of the window;
int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

void settings(){
  size(WIDTH, HEIGHT);
}
void setup(){
  for(int i = 0; i<= numberOfLevels; i++){
    // 6 to the power of 0 is 1
    // 6 to the power of 1 is 6
    // 6 to the power of 2 is 36 etc.
    //PVector[] newLevel = new PVector[int(pow(numberOfRadiusPoints, i))];
    levels.add(new PVector[ int(pow(numberOfRadiusPoints, i)) ]);

  }
  
  for(int i = 0; i <= numberOfLevels; i++){
    PVector[] currentLevel = levels.get(i);
    PVector[] previousLevel = (i != 0) ? levels.get(i-1) : new PVector[0];
    println(i);
    println("Current Level Size: " + currentLevel.length);
    println("Previous Level Size: " + previousLevel.length);
    
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
      
      //noStroke();
      //fill(255, 0, 0);
      //ellipse(currentLevel[j].x, currentLevel[j].y, dotRadius, dotRadius);
      
      stroke(255);
      if( i%2 == 0){ // only the even levels
        fill(255*i, 125, 125, 40); 
      }
      else {
        fill(75, 10);
      }
      ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);
      
      
      totalPoints++;
      //if(i == 2) text(totalPoints, currentLevel[j].x, currentLevel[j].y+j);
    }
  }

  fill(0);
  text("Number of Levels: " + levels.size(), 10, height - 30);
  text("Number of points: " + totalPoints, 10, height - 10);
}
