ArrayList<SymmetricalShape> shapes = new ArrayList<SymmetricalShape>();

int numberOfVerts = 6;
float cR = 100;

boolean createRelated = true;

void setup(){
  size(500, 500);
  
}

void draw(){
  background(200);
  
  for (int i = 0; i < shapes.size(); i++) {
    SymmetricalShape shape = shapes.get(i);
    shape.display();
    //shape.displayRelatedCentersThroughSides();
  }
  
  fill(0);
  text("Number Of Vertices: " + numberOfVerts, 10, height - 40);
  text("Radius: " + cR, 10, height - 20);
  
  text("Create Related? " + createRelated, 170,  height - 40);
  //text("Black Dot y = " + py, 170,  height - 20);
}


void keyReleased(){
  switch(key){
    case CODED:
      if(keyCode == UP && numberOfVerts < 8){
        numberOfVerts++;
      }
      if(keyCode == DOWN && numberOfVerts > 3){
        numberOfVerts--;
      }
      if(keyCode == LEFT && cR < width ){
        cR+=10;
      }
      if(keyCode == RIGHT && cR > 10){
        cR-=10;
      }
      break;
    case 'n':
      SymmetricalShape sS = new SymmetricalShape(numberOfVerts, cR, new PVector(width/2, height/2));
      shapes.add(sS);
      if(createRelated){
        PVector[] relatedPoints = sS.getRelatedCenterPoints();
        for(int i = 0; i < relatedPoints.length; i++){
          shapes.add(new SymmetricalShape(numberOfVerts, cR, relatedPoints[i]));
        }
      }
      break;
    case 'r':
      createRelated = !createRelated;
      break;
  } // endof key switch
  
}// end of keyReleased





void calculateGridPoints(){

  //ArrayList<PVector> centerPoints = new ArrayList<PVector>();
  //centerPoints.add( new PVector(width/2, height/2) );
  
  //SymmetricalShape sS = new SymmetricalShape(numberOfVerts, cR, centerPoint);
  
  //for( int i = 1; i <= sS.getPoints().length; i++ ){
    
  //  PVector newPoint = new PVector();
  //  if( (newPoint.x > 0-cR || newPoint.x < width+cR) && (newPoint.y > 0-cR || newPoint.y < height+cR) ){
  //  }
  //}
}
