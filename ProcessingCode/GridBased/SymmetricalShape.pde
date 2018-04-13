class SymmetricalShape{

  PShape shape;
  float cR = 100; // circle Radius
  float midSideR; // radius of a circle subscribed through the midside points
  
  int numberOfVerts = 6;
  
  
  PVector[] points;
  PVector[] relatedCentersThroughSides;
  
  color[] relatedCenterColors;
  
  SymmetricalShape(int numOfVert, float circleR, PVector centerPoint){
    numberOfVerts = numOfVert;
    cR = circleR;
        
    float radianStep = TWO_PI/numberOfVerts;
    
    midSideR = cos(radianStep/2)*(cR);
    points = new PVector[numberOfVerts+1];
    relatedCentersThroughSides = new PVector[numberOfVerts];
    relatedCenterColors = new color[numberOfVerts];
    
    //make a shape
    shape = createShape();
    shape.beginShape();
    for(int i = 0; i <= numberOfVerts; i++){
      float pointX = centerPoint.x + (cos(radianStep*i) * cR);
      float pointY = centerPoint.y + (sin(radianStep*i) * cR);
      points[i] = new PVector( pointX, pointY );
      shape.vertex( pointX, pointY );
    }

    shape.endShape();
    shape.setFill(color(255, 255, 255, 1));
    shape.setStroke(color(random(255), random(255), random(255)));
    
    //calculate the centerpoints through the midpoints of sides
    for( int i = 0; i < numberOfVerts; i++){
      float pointX = centerPoint.x + (cos(radianStep*i-(PI/numberOfVerts)) * midSideR * 2);
      float pointY = centerPoint.y + (sin(radianStep*i-(PI/numberOfVerts)) * midSideR * 2);
      relatedCentersThroughSides[i] = new PVector( pointX, pointY );
      relatedCenterColors[i] = color(random(255), random(255), random(255));
    }
  }
  
  PVector[] getPoints(){
    return points;
  }
  
  void display(){
    shape(shape, 0, 0);
  }
  
  PVector[] getRelatedCenterPoints(){
    return relatedCentersThroughSides;
  }
  
  void displayRelatedCentersThroughSides(){
    for(int i = 0; i < relatedCentersThroughSides.length; i++){
      stroke(color(255, 255, 255, 1));
      fill(relatedCenterColors[i]);
      ellipse(relatedCentersThroughSides[i].x, relatedCentersThroughSides[i].y, 5, 5);
      noFill();
    }
  }

}
