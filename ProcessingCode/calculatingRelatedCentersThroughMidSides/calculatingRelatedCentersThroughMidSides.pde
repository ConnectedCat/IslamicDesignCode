float cR = 100; // circle Radius
float midSideR; // radius of a circle touching the middles of sides
int numberOfVerts = 6;

float radianStep = TWO_PI/numberOfVerts; //angle in radians
PShape shape;

PVector[] points, sideMids;

color blue = color(0, 0, 255);
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color cyan = color(0, 255, 255);
color magenta = color(255, 0, 255);
color yellow = color(255, 255, 0);
color white = color(255, 255, 255);
color black = color(0);

PVector blueCorner, redCorner, greenCorner, cyanCorner, magentaCorner, yellowCorner, centerPoint;

void setup(){
  size(500, 500);
  
  points = new PVector[numberOfVerts+1];
  sideMids = new PVector[numberOfVerts];
  centerPoint = new PVector(width/2, height/2);
  
  shape = createShape();
  shape.beginShape();
  
  for(int i = 0; i <= numberOfVerts; i++){
    
    float pointX = centerPoint.x + (cos(radianStep*i) * cR);
    float pointY = centerPoint.y + (sin(radianStep*i) * cR);
    
    points[i] = new PVector( pointX, pointY );
    shape.vertex( pointX, pointY );
  } 
  
  midSideR = cos(radianStep/2)*(cR);
  
  for( int i = 0; i < numberOfVerts; i++){
    
    float pointX = centerPoint.x + (cos(radianStep*i-(PI/numberOfVerts)) * midSideR * 2);
    float pointY = centerPoint.y + (sin(radianStep*i-(PI/numberOfVerts)) * midSideR * 2);
    
    sideMids[i] = new PVector( pointX, pointY );
  }
  
  shape.endShape();
  shape.setFill(color(255, 255, 255, 1));
  shape.setStroke(color(random(255), random(255), random(255)));
  
}

void draw(){
  noStroke();
  fill(black);
  ellipse(width/2, height/2, 5, 5);
  
  for( int i = 0; i < numberOfVerts; i++){
    switch(i){
      case 0:
        fill(blue);
        break;
      case 1:
        fill(red);
        break;
      case 2:
        fill(green);
        break;
      case 3:
        fill(cyan);
        break;
      case 4:
        fill(magenta);
        break;
      case 5:
        fill(yellow);
        break;
      default:
        fill(black);
        break;
    }
    ellipse(sideMids[i].x, sideMids[i].y, 5, 5);
  }
  
  noFill();
  
  shape(shape, 0, 0); 
}
