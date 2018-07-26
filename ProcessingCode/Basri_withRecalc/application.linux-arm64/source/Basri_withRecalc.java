import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.io.*; 
import processing.io.SPI; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Basri_withRecalc extends PApplet {


MCP3008 adc;

float[] pots = new float[8];
float tolerance = 0.01f;

ArrayList<PVector[]> levels = new ArrayList<PVector[]>();

PVector centerPoint;

int WIDTH = 800;
int HEIGHT = 600;

float circleDiameter = 200;
float minDiameter;
float maxDiameter = 250;
float circleRadius = circleDiameter/2;

int minNumRadPoints = 4;
int maxNumRadPoints = 12;
int numberOfRadiusPoints = 4;

int numberOfLevels = 3;
float angleInRadians = TWO_PI/numberOfRadiusPoints;

int mainColor, backgroundColor;

public void settings() {
  size(WIDTH, HEIGHT);
  adc = new MCP3008(SPI.list()[0]);
}

public void setup() {
  colorMode(HSB, TWO_PI, 100, 100, 100);  
  calcTheLevels();
}

public void draw() {
  PVector[] currentLevel = levels.get(levels.size() - 1);
  
  readPotValues();
  
  mainColor = color(TWO_PI*pots[2], 100*pots[1], 100*pots[0]);
  backgroundColor = color(TWO_PI*pots[6], 100*pots[7], map(pots[0], 1, 0, 0, 100), 100*pots[5]);
  
  noStroke();
  fill(backgroundColor);
  rect(0, 0, width, height);
  
  circleDiameter = map(pots[4], 0, 1, minDiameter, maxDiameter);
  
  for (int j = 0; j < currentLevel.length; j++) {
    // draw the circles
    stroke(mainColor);
    noFill();
    ellipse(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter);

    //draw the arches
    fill(mainColor);
    noStroke();

    int halfPoint = numberOfRadiusPoints/2;
    float startAngle, stopAngle;
    if (numberOfRadiusPoints % 2 == 0) { //for even number of points

      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j)+angleInRadians;

      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);

      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;
      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    } 
    else {
      startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
      stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;

      arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle, CHORD);
    }
  }// for all elements on this level
}//end of draw


//
//
// ALL THE FUNCTIONS USED
//
//

public void calcTheLevels() {
  levels.clear();
  for (int i = 0; i <= numberOfLevels; i++) {
    levels.add(new PVector[ PApplet.parseInt(pow(numberOfRadiusPoints, i)) ]);
  }

  for (int i = 0; i <= numberOfLevels; i++) {
    PVector[] currentLevel = levels.get(i);
    PVector[] previousLevel = (i != 0) ? levels.get(i-1) : new PVector[0];

    for (int j = 0; j < currentLevel.length; j++) {
      if (i != 0) {
        centerPoint = previousLevel[floor(j/numberOfRadiusPoints)];
        float pointX = centerPoint.x + cos(angleInRadians*j)*circleRadius;
        float pointY = centerPoint.y + sin(angleInRadians*j)*circleRadius;
        currentLevel[j] = new PVector(pointX, pointY);
      } else {
        currentLevel[j] = new PVector(width/2, height/2);
      }
    }
  }
  
  // calc min and max diamater
  PVector zeroPoint = new PVector(centerPoint.x+(cos(0)*circleRadius), centerPoint.y+(sin(0)*circleRadius));
  PVector anglePoint = new PVector(centerPoint.x+(cos(angleInRadians)*circleRadius), centerPoint.y+(sin(angleInRadians)*circleRadius));
  
  float archHeight = circleRadius - (cos(angleInRadians/2)*circleRadius);
  
  minDiameter = PVector.dist(zeroPoint, anglePoint) + (archHeight);
}

public void readPotValues() {
  for (int i = 0; i < pots.length; i++) {
    float potVal = adc.getAnalog(i);

    if (i==3 ) {
      if (abs(potVal - pots[3]) > (float)1/(maxNumRadPoints-minNumRadPoints)) {
        pots[3] = potVal;
        numberOfRadiusPoints = round(map(pots[3], 1, 0, minNumRadPoints, maxNumRadPoints));
        angleInRadians = TWO_PI/numberOfRadiusPoints;
        thread("calcTheLevels");
      }
    } else {
      if (abs(potVal - pots[i]) > tolerance ) {
        pots[i] = potVal;
      }
    }
  }
}


// MCP3008 is a Analog-to-Digital converter using SPI
// other than the MCP3001, this has 8 input channels
// datasheet: http://ww1.microchip.com/downloads/en/DeviceDoc/21295d.pdf

class MCP3008 extends SPI {

  MCP3008(String dev) {
    super(dev);
    settings(500000, SPI.MSBFIRST, SPI.MODE0);
  }

  public float getAnalog(int channel) {
    if (channel < 0 ||  7 < channel) {
      System.err.println("The channel needs to be from 0 to 7");
      throw new IllegalArgumentException("Unexpected channel");
    }
    byte[] out = { 0, 0, 0 };
    // encode the channel number in the first byte
    out[0] = (byte)(0x18 | channel);
    byte[] in = super.transfer(out);
    int val = ((in[1] & 0x3f) << 4 ) | ((in[2] & 0xf0) >> 4 );
    // val is between 0 and 1023
    return PApplet.parseFloat(val)/1023.0f;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "Basri_withRecalc" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
