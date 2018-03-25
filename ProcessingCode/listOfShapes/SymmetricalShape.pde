class SymmetricalShape{

  PShape shape;
  float cR = 100; // circle Radius
  int numberOfVerts = 6;
  
  color blue = color(0, 0, 255);
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  color cyan = color(0, 255, 255);
  color magenta = color(255, 0, 255);
  color yellow = color(255, 255, 0);
  color white = color(255, 255, 255);
  color black = color(0);
  
  PVector[] points;
  
  SymmetricalShape(int numOfVert, float circleR, PVector centerPoint){
    numberOfVerts = numOfVert;
    cR = circleR;
        
    float radianStep = TWO_PI/numberOfVerts;
    
    shape = createShape();
    shape.beginShape();
    points = new PVector[numberOfVerts+1];
    
    for(int i = 0; i <= numberOfVerts; i++){
      points[i] = new PVector(centerPoint.x + (cos(radianStep*i-HALF_PI) * cR), centerPoint.y + (sin(radianStep*i-HALF_PI) * cR));
      shape.vertex(centerPoint.x + (cos(radianStep*i-HALF_PI) * cR), centerPoint.y + (sin(radianStep*i-HALF_PI) * cR) );
    } 
    shape.endShape();
    shape.setFill(color(255, 255, 255, 1));
    shape.setStroke(color(random(255), random(255), random(255)));
  }
  
  PVector[] getPoints(){
    return points;
  }
  
  void display(){
    shape(shape, 0, 0);
  }
  
  
  
}
