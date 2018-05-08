ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 1000;
int HEIGHT = 1000;

float circleDiameter = 200;
float circleRadius = circleDiameter/2;
float dotRadius = 5;
int numberOfRadiusPoints = 7;

int totalPoints = 0;
int numberOfLevels = 4;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

void settings(){
  size(WIDTH, HEIGHT);
}

void setup(){
  for(int i = 0; i <= numberOfLevels; i++){
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
      totalPoints++;
    }
  }

  fill(0);
  text("Number of Levels: " + levels.size(), 10, height - 30);
  text("Number of points: " + totalPoints, 10, height - 10);
}

void draw(){
  background(15, 175, 175);
  
  for(int i = 0; i <= numberOfLevels; i++){
    if(i == levels.size() - 1){
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

        stroke(255);
        noFill();
        ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);
        
        fill(255, 0, 0);
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
