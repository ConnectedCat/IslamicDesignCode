ArrayList<SymmetricalShape> shapes = new ArrayList<SymmetricalShape>();
ArrayList<PVector[]> centerPoints = new ArrayList<PVector[]>();

int levelIndex = 0;
int numberOfVerts = 6;
float cR = 100;

void setup(){
  size(500, 500);
  PVector[] vectors = new PVector[1];
  vectors[0] = new PVector(width/2, height/2);
  centerPoints.add(vectors);
}

void draw(){
  for (int i = 0; i < shapes.size(); i++) {
    SymmetricalShape shape = shapes.get(i);
    shape.display();
  }
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
      PVector[] vectors = centerPoints.get(levelIndex);
      for(int i = 0; i < vectors.length; i++ ){
        SymmetricalShape sS = new SymmetricalShape(numberOfVerts, cR, vectors[i]);
        centerPoints.add(sS.getPoints());
        shapes.add(sS);
      }
      levelIndex++;
      break;
  }
  
}
