import ddf.minim.analysis.*;
import ddf.minim.*;


Minim       minim;
AudioInput  lineIn;
FFT         myFFT;

float       colorPlane[][][] = new float[256][256][3];
float       deltaMap[][][] = new float[800][800][2];


float       bandFocus, intensity, bandSkew;
boolean     flipSpectrum, glowEffect, gray;
float       lx1, ly1, lx2, ly2, rx1, ry1, rx2, ry2;
float       ldx1, ldy1, ldx2, ldy2, rdx1, rdy1, rdx2, rdy2;
int         blitCounter, symmetry;
String      oldDisplay;

PImage      frameBuffer;




int xPix = 800, yPix = 800, nMirrors = 5;


PixelPoint[][] pointSet = new PixelPoint[xPix][yPix];
MirrorWall[]   reflections = new MirrorWall[nMirrors];

PImage photo;

void setup()
{
  int x, y, n, m;
  
  byte[] dMapFile;
  
  /*
  for(y=0;y<yPix;y++)
  {
    for(x=0;x<xPix;x++)
    {
      pointSet[x][y] = new PixelPoint(0, 0, (x-(xPix/2 - 0.5))/260.0, (y-(yPix/2 - 0.5))/260.0);
    }
  }
  
  for(y=0;y<nMirrors;y++)
  {
    reflections[y] = new MirrorWall(100.0, y*2.0*PI/nMirrors);
  }
  */
  
  size(800,850);
  frameRate(30);
  background(0);
  //colorMode(HSB, 255);
  
 /*
  println("Generating Delta Map...");
  
  for(n=0;n<160;n++)
  {
    for(y=0;y<yPix;y++)
    {
      for(x=0;x<xPix;x++)
      {   
  
          pointSet[x][y].move();
        for(m=0;m<nMirrors;m++)
          pointSet[x][y].checkMirror(reflections[m]);
      }
    }
    if((n%5)==0)
      print(".");
  }
  println("done.");
  for(y=0;y<yPix;y++)
  {
    for(x=0;x<xPix;x++)
    {   
      deltaMap[x][y][0] = pointSet[x][y].x + 127.5;
      deltaMap[x][y][1] = pointSet[x][y].y + 127.5;
      
      int idx = (y*800+x)*8;
      int tmp = floor(deltaMap[x][y][0] * 65536); 
      dMapFile[idx] = byte((tmp >> 24) & 0xFF);
      dMapFile[idx+1] = byte((tmp >> 16) & 0xFF);
      dMapFile[idx+2] = byte((tmp >> 8) & 0xFF);
      dMapFile[idx+3] = byte((tmp) & 0xFF);
      
      tmp = floor(deltaMap[x][y][1] * 65536); 
      dMapFile[idx+4] = byte((tmp >> 24) & 0xFF);
      dMapFile[idx+5] = byte((tmp >> 16) & 0xFF);
      dMapFile[idx+6] = byte((tmp >> 8) & 0xFF);
      dMapFile[idx+7] = byte((tmp) & 0xFF);
      
    }
  }
  println("floated.");
  saveBytes("mirror5.dat", dMapFile);
  */
  
  dMapFile = loadBytes("mirror5.dat"); //There are other sample delta maps in the folder. Try them!
  if (dMapFile == null)
  {
    println("Oh shoot. Can't load the delta map!");
    exit();
  }
  
  for(y=0;y<yPix;y++)
  {
    for(x=0;x<xPix;x++)
    {   
      int tmp;
      int idx = (y*800+x)*8;

      tmp = dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      idx++;
      deltaMap[x][y][0] = tmp/65536.0;
      
      tmp = dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      tmp <<= 8;
      idx++;
      tmp |= dMapFile[idx] & 0xFF;
      
      deltaMap[x][y][1] = tmp/65536.0; 
      
      
    }
  }
  
  
  
  frameBuffer = createImage(width, height - 50, RGB);

  
  thread("spectrumThread");

}

void draw()
{
  int x, y, m;
  int yo = (height - 50 - yPix)/2;
  int xo = (width - xPix)/2;
  int j;
  String display;
  //background(0);
  
  image(frameBuffer, 0, 0);

  

  
  
  display = "Focus: " + nf(bandFocus, 2, 2) + "   Intensity: " + nf(intensity, 2, 2);
  display = display + "   Band Skew: "+ nf(bandSkew, 2, 2) + "\n";
  switch (symmetry)
  {
    case 0:
      display = display + "No ";
      break;
    case 1:
      display = display + "Vertical ";
      break;
    case 2:
      display = display + "Horizontal ";
      break;
    case 3:
      display = display + "Two-fold Bilateral ";
      break;
    case 4:
      display = display + "Four-fold Rotational ";
      break;
    case 5:
      display = display + "Four-fold Bilateral ";
      break;
    case 6:
      display = display + "Five-Fold Rotational ";
      break;
    case 7:
      display = display + "Five-fold Bilateral ";
      break;
    case 8:
      display = display + "Ten-fold Rotational ";
      break;
    case 9:
      display = display + "Six-fold Rotational ";
      break;
    case 10:
      display = display + "Six-fold Bilateral ";
      break;
    default:
      display = display + "Mysterious ";
      break;
  }
  display = display + "Symmetry.   Flip: ";
  
  if(flipSpectrum)
  {
    display = display + "On";
  }
  else
  {
    display = display + "Off";
  }
  
  display = display + "   Glow: ";
  if(glowEffect)
  {
    display = display + "On";
  }
  else
  {
    display = display + "Off";
  }

  display = display + "   Gray: ";
  if(gray)
  {
    display = display + "On";
  }
  else
  {
    display = display + "Off";
  }  
  
  if (!display.equals(oldDisplay))
  {
    fill(0,0,0);
    noStroke();
    rect(0, yPix, xPix, 50);
    fill(128,128,128);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(display, xPix/2, yPix + 25);
    oldDisplay = display;
  }
  
}

void spectrumLine(float[] intensities, float x1, float y1, float x2, float y2)
{
  int j;
  
  
  for(j=0;j<283;j++)
  {
    float xx = (x1*(282 - j) + x2*j)/282;
    float yy = (y1*(282 - j) + y2*j)/282;
    int px = floor(xx);
    int py = floor(yy);
    
    if ((px < 0) || (px > 255) || (py < 0) || (py > 255))
      continue;
    
    float highX = xx - floor(xx);
    float lowX = 1.0 - highX;
    float highY = yy - floor(yy);
    float lowY = 1.0 - highY;
    
    colorPlane[px][py][0] += wavelengthTable[j+42][1]*intensities[j]*lowX*lowY;
    colorPlane[px][py][1] += wavelengthTable[j+42][2]*intensities[j]*lowX*lowY;
    colorPlane[px][py][2] += wavelengthTable[j+42][3]*intensities[j]*lowX*lowY;
    if (xx < 255)
    {
      colorPlane[px+1][py][0] += wavelengthTable[j+42][1]*intensities[j]*highX*lowY;
      colorPlane[px+1][py][1] += wavelengthTable[j+42][2]*intensities[j]*highX*lowY;
      colorPlane[px+1][py][2] += wavelengthTable[j+42][3]*intensities[j]*highX*lowY;
    }
    if (yy < 255)
    {
      colorPlane[px][py+1][0] += wavelengthTable[j+42][1]*intensities[j]*lowX*highY;
      colorPlane[px][py+1][1] += wavelengthTable[j+42][2]*intensities[j]*lowX*highY;
      colorPlane[px][py+1][2] += wavelengthTable[j+42][3]*intensities[j]*lowX*highY;
    }
    if ((xx < 255) && (yy < 255))
    {
      colorPlane[px+1][py+1][0] += wavelengthTable[j+42][1]*intensities[j]*highX*highY;
      colorPlane[px+1][py+1][1] += wavelengthTable[j+42][2]*intensities[j]*highX*highY;
      colorPlane[px+1][py+1][2] += wavelengthTable[j+42][3]*intensities[j]*highX*highY;
    }  
  }
}


color PlanePixel(float x, float y)
{
  if ((x > 255) || (x < 0) || (y > 255) || (y < 0))
    return color(0);
    
  float cx, cy, cz;
  float r, g, b, m;
  int lpx, lpy, hpx, hpy;
  float fx, fy, fxy;
  
  lpx = floor(x);
  lpy = floor(y);
  hpx = min(lpx+1, 255);
  hpy = min(lpy+1, 255);
  fx = x - lpx;
  fy = y - lpy;
  fxy = fx*fy;
  
  cx = colorPlane[lpx][lpy][0]*(1.0-fx-fy+fxy) + colorPlane[hpx][lpy][0]*(fx-fxy) + colorPlane[lpx][hpy][0]*(fy-fxy) + colorPlane[hpx][hpy][0]*fxy;
  cy = colorPlane[lpx][lpy][1]*(1.0-fx-fy+fxy) + colorPlane[hpx][lpy][1]*(fx-fxy) + colorPlane[lpx][hpy][1]*(fy-fxy) + colorPlane[hpx][hpy][1]*fxy;
  cz = colorPlane[lpx][lpy][2]*(1.0-fx-fy+fxy) + colorPlane[hpx][lpy][2]*(fx-fxy) + colorPlane[lpx][hpy][2]*(fy-fxy) + colorPlane[hpx][hpy][2]*fxy;
  
  r = 2.9515373*cx - 1.2894116*cy - 0.4738445*cz;
  g = -1.0851093*cx + 1.9908566*cy + 0.0372026*cz;
  b = 0.0854934*cx - 0.2694964*cy + 1.0912975*cz;

  m = min(r,g,b);
  if (m < 0)
  {
    r = r-m;
    g = g-m;
    b = b-m;
  }
 
 /*
  r = pow(r, 0.5);
  g = pow(g, 0.5);
  b = pow(b, 0.5);
  */
  
  r = sqrt(r);
  g = sqrt(g);
  b = sqrt(b);
  
  return color(r*128, g*128, b*128);
}

void dimPlane()
{
  int x,y;
  
  for(x=0;x<256;x++)
  {
    for(y=0;y<256;y++)
    {
      colorPlane[x][y][0] *= 0.95;
      colorPlane[x][y][1] *= 0.95;
      colorPlane[x][y][2] *= 0.95;
    }
  }

  if (gray)
  {
    for(x=0;x<256;x++)
    {
      for(y=0;y<256;y++)
      {
        colorPlane[x][y][0] += 0.0095047/2.0;
        colorPlane[x][y][1] += 0.0100000/2.0;
        colorPlane[x][y][2] += 0.0108883/2.0;
      }
    }
  }
}




void keyPressed()
{
  if (key == 'f')
  {
    bandFocus -= 0.05;
  }
  else if (key == 'F')
  {
    bandFocus += 0.05;
  }
  else if (key == 'i')
  {
    intensity -= 0.05;
    if (intensity < 0)
      intensity = 0;
  }
  else if (key == 'I')
  {
    intensity += 0.05;
  }
  else if (key == 's')
  {
    bandSkew -= 0.05;
  }
  else if (key == 'S')
  {
    bandSkew += 0.05;
  }
  else if (key == 'y')
  {
    symmetry--;
    if (symmetry < 0)
    {
      symmetry+=11;
    }
  }
  else if (key == 'Y')
  {
    symmetry++;
    if (symmetry > 10)
    {
      symmetry-=11;
    }
  }
  else if (key == '/')
  {
    flipSpectrum = !flipSpectrum;
  }
  else if (key == 'g')
  {
    glowEffect = !glowEffect;
  }
  else if (key == 'j')
  {
    gray = !gray;
  }
  
  
}

void updateLines()
{
  lx1 += ldx1;
  ly1 += ldy1;
  lx2 += ldx2;
  ly2 += ldy2;
  rx1 += rdx1;
  ry1 += rdy1;
  rx2 += rdx2;
  ry2 += rdy2;
  
  if (lx1 < 0)
  {
    lx1 = -lx1;
    ldx1 = -ldx1;
  }
  
  if (lx2 < 0)
  {
    lx2 = -lx2;
    ldx2 = -ldx2;
  }
  
  if (ly1 < 0)
  {
    ly1 = -ly1;
    ldy1 = -ldy1;
  }
  
  if (ly2 < 0)
  {
    ly2 = -ly2;
    ldy2 = -ldy2;
  }
  
  if (rx1 < 0)
  {
    rx1 = -rx1;
    rdx1 = -rdx1;
  }
  
  if (rx2 < 0)
  {
    rx2 = -rx2;
    rdx2 = -rdx2;
  }
  
  if (ry1 < 0)
  {
    ry1 = -ry1;
    rdy1 = -rdy1;
  }
  
  if (ry2 < 0)
  {
    ry2 = -ry2;
    rdy2 = -rdy2;
  }
  
  if (lx1 > 255)
  {
    lx1 = 510-lx1;
    ldx1 = -ldx1;
  }
  
  if (lx2 > 255)
  {
    lx2 = 510-lx2;
    ldx2 = -ldx2;
  }
  
  if (ly1 > 255)
  {
    ly1 = 510-ly1;
    ldy1 = -ldy1;
  }
  
  if (ly2 > 255)
  {
    ly2 = 510-ly2;
    ldy2 = -ldy2;
  }
  
  if (rx1 > 255)
  {
    rx1 = 510-rx1;
    rdx1 = -rdx1;
  }
  
  if (rx2 > 255)
  {
    rx2 = 510-rx2;
    rdx2 = -rdx2;
  }
  
  if (ry1 > 255)
  {
    ry1 = 510-ry1;
    rdy1 = -rdy1;
  }
  
  if (ry2 > 255)
  {
    ry2 = 510-ry2;
    rdy2 = -rdy2;
  }
  
  //Now add some "quiggle"
  ldx1 += (random(10) - random(10))*0.005;
  ldx2 += (random(10) - random(10))*0.005;
  ldy1 += (random(10) - random(10))*0.005;
  ldy2 += (random(10) - random(10))*0.005;
  rdx1 += (random(10) - random(10))*0.005;
  rdx2 += (random(10) - random(10))*0.005;
  rdy1 += (random(10) - random(10))*0.005;
  rdy2 += (random(10) - random(10))*0.005;
  
  //Keep travel speeds sane.
  if(sqrt(ldx1*ldx1+ldy1*ldy1) > 2.0)
  {
    ldx1 *= 0.95;
    ldy1 *= 0.95;
  }
  
  if(sqrt(ldx2*ldx2+ldy2*ldy2) > 2.0)
  {
    ldx2 *= 0.95;
    ldy2 *= 0.95;
  }
  
  if(sqrt(rdx1*rdx1+rdy1*rdy1) > 2.0)
  {
    rdx1 *= 0.95;
    rdy1 *= 0.95;
  }
  
  if(sqrt(rdx2*rdx2+rdy2*rdy2) > 2.0)
  {
    rdx2 *= 0.95;
    rdy2 *= 0.95;
  }
}


void spectrumThread()
{
  int x, y, m;
  int yo = (height - 50 - yPix)/2;
  int xo = (width - xPix)/2;

  int j;
  
  float       lspectrum[] = new float[283];
  float       rspectrum[] = new float[283];
  
  bandFocus = 1.50;
  intensity = 0.55;
  bandSkew = -0.35;
  symmetry = 6;
  
  minim = new Minim(this);
  
  lx1 = random(width);
  lx2 = random(width);
  rx1 = random(width);
  rx2 = random(width);
  
  ly1 = random(height);
  ly2 = random(height);
  ry1 = random(height);
  ry2 = random(height);
  
  ldx1 = (random(10) - random(10))*0.1;
  ldy1 = (random(10) - random(10))*0.1;
  ldx2 = (random(10) - random(10))*0.1;
  ldy2 = (random(10) - random(10))*0.1;
  rdx1 = (random(10) - random(10))*0.1;
  rdy1 = (random(10) - random(10))*0.1;
  rdx2 = (random(10) - random(10))*0.1;
  rdy2 = (random(10) - random(10))*0.1;
 
  
  lineIn = minim.getLineIn(Minim.STEREO, 1024);
  myFFT = new FFT(lineIn.bufferSize(), lineIn.sampleRate());
  myFFT.linAverages(256);
  
  if (myFFT == null || lineIn == null)
    return;
  
  
  while( myFFT != null && lineIn != null)
  {
    
     frameBuffer.loadPixels();
  
     for(y=0;y<yPix;y++)
     {
       for(x=0;x<xPix;x++)
       {   
         frameBuffer.pixels[width*(yo+y) + xo+x] = PlanePixel((deltaMap[x][y][0]), (deltaMap[x][y][1]));
       }
     }
     frameBuffer.updatePixels();

    
    dimPlane();
    
  
    myFFT.forward(lineIn.left);
    
    for(j=0;j<283;j++)
    {
      if(j<14 || j > 269)
      {
        lspectrum[j] = 0;
      }
      else
      {
        float level;
        if(flipSpectrum)
        {
          level = myFFT.getAvg(j-14);        
          level *= exp(((259.0-j)/32.0)*bandSkew);
        }
        else
        {
          level = myFFT.getAvg(269-j);
          level *= exp(((j-32.0)/32.0)*bandSkew);
        }  
        level *= intensity;
        level = pow(level, bandFocus);
        lspectrum[j] = level;
      }
    }
      
    myFFT.forward(lineIn.right);
    
      
    for(j=0;j<283;j++)
    {
      if(j<14 || j > 269)
      {
        rspectrum[j] = 0;
      }
      else
      {
        float level;
        if(flipSpectrum)
        {
          level = myFFT.getAvg(j-14);        
          level *= exp(((259.0-j)/32.0)*bandSkew);
        }
        else
        {
          level = myFFT.getAvg(269-j);
          level *= exp(((j-32.0)/32.0)*bandSkew);
        }  
        level *= intensity;
        level = pow(level, bandFocus);
        rspectrum[j] = level;
      }
    }

    for(j=0;j<9;j++)
    {
      updateLines();
      spectrumLine(lspectrum, lx1, ly1, lx2, ly2);
      spectrumLine(rspectrum, rx1, ry1, rx2, ry2);
      
      if ((symmetry==1) || (symmetry==3) || (symmetry==5) || (symmetry==10))
      { 
        spectrumLine(lspectrum, 255-lx1, ly1, 255-lx2, ly2);
        spectrumLine(rspectrum, 255-rx1, ry1, 255-rx2, ry2);
      }
      
      if ((symmetry==2) || (symmetry==3) || (symmetry==5) || (symmetry==10))
      {
        spectrumLine(lspectrum, lx1, 255-ly1, lx2, 255-ly2);
        spectrumLine(rspectrum, rx1, 255-ry1, rx2, 255-ry2);
      }
      
      if ((symmetry==3) || (symmetry==4) || (symmetry==5) || (symmetry==8) || (symmetry==9) || (symmetry==10))
      {
        spectrumLine(lspectrum, 255-lx1, 255-ly1, 255-lx2, 255-ly2);
        spectrumLine(rspectrum, 255-rx1, 255-ry1, 255-rx2, 255-ry2);
      }
      
      if ((symmetry==5)||(symmetry==7))
      {
        spectrumLine(lspectrum, ly1, lx1, ly2, lx2);
        spectrumLine(rspectrum, ry1, rx1, ry2, rx2);
      }
      
      if ((symmetry==4) || (symmetry == 5))
      {
        spectrumLine(lspectrum, 255-ly1, lx1, 255-ly2, lx2);
        spectrumLine(rspectrum, 255-ry1, rx1, 255-ry2, rx2);
      
        spectrumLine(lspectrum, ly1, 255-lx1, ly2, 255-lx2);
        spectrumLine(rspectrum, ry1, 255-rx1, ry2, 255-rx2);
      }
      
      if ((symmetry==5))
      {
        spectrumLine(lspectrum, 255-ly1, 255-lx1, 255-ly2, 255-lx2);
        spectrumLine(rspectrum, 255-ry1, 255-rx1, 255-ry2, 255-rx2);  
      }
      
      if ((symmetry==6) || (symmetry==7) || (symmetry==8))
      {
        float nx1, ny1, nx2, ny2;
        
        nx1 = 128 + 0.309016994*(lx1-128) - 0.951056516*(ly1-128);
        ny1 = 128 + 0.951056516*(lx1-128) + 0.309016994*(ly1-128);
        nx2 = 128 + 0.309016994*(lx2-128) - 0.951056516*(ly2-128);
        ny2 = 128 + 0.951056516*(lx2-128) + 0.309016994*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(lspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 + 0.309016994*(rx1-128) - 0.951056516*(ry1-128);
        ny1 = 128 + 0.951056516*(rx1-128) + 0.309016994*(ry1-128);
        nx2 = 128 + 0.309016994*(rx2-128) - 0.951056516*(ry2-128);
        ny2 = 128 + 0.951056516*(rx2-128) + 0.309016994*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(rspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 + 0.309016994*(lx1-128) + 0.951056516*(ly1-128);
        ny1 = 128 - 0.951056516*(lx1-128) + 0.309016994*(ly1-128);
        nx2 = 128 + 0.309016994*(lx2-128) + 0.951056516*(ly2-128);
        ny2 = 128 - 0.951056516*(lx2-128) + 0.309016994*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(lspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 + 0.309016994*(rx1-128) + 0.951056516*(ry1-128);
        ny1 = 128 - 0.951056516*(rx1-128) + 0.309016994*(ry1-128);
        nx2 = 128 + 0.309016994*(rx2-128) + 0.951056516*(ry2-128);
        ny2 = 128 - 0.951056516*(rx2-128) + 0.309016994*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(rspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 - 0.809016994*(lx1-128) - 0.587785252*(ly1-128);
        ny1 = 128 + 0.587785252*(lx1-128) - 0.809016994*(ly1-128);
        nx2 = 128 - 0.809016994*(lx2-128) - 0.587785252*(ly2-128);
        ny2 = 128 + 0.587785252*(lx2-128) - 0.809016994*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(lspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 - 0.809016994*(rx1-128) - 0.587785252*(ry1-128);
        ny1 = 128 + 0.587785252*(rx1-128) - 0.809016994*(ry1-128);
        nx2 = 128 - 0.809016994*(rx2-128) - 0.587785252*(ry2-128);
        ny2 = 128 + 0.587785252*(rx2-128) - 0.809016994*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(rspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 - 0.809016994*(lx1-128) + 0.587785252*(ly1-128);
        ny1 = 128 - 0.587785252*(lx1-128) - 0.809016994*(ly1-128);
        nx2 = 128 - 0.809016994*(lx2-128) + 0.587785252*(ly2-128);
        ny2 = 128 - 0.587785252*(lx2-128) - 0.809016994*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(lspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        
        nx1 = 128 - 0.809016994*(rx1-128) + 0.587785252*(ry1-128);
        ny1 = 128 - 0.587785252*(rx1-128) - 0.809016994*(ry1-128);
        nx2 = 128 - 0.809016994*(rx2-128) + 0.587785252*(ry2-128);
        ny2 = 128 - 0.587785252*(rx2-128) - 0.809016994*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        if (symmetry==7)
          spectrumLine(rspectrum, ny1, nx1, ny2, nx2);
        if (symmetry==8)
          spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
          
      }
      
      if((symmetry==9) || (symmetry==10))
      {
        float nx1, ny1, nx2, ny2;
        
        nx1 = 128 + 0.5*(lx1-128) - 0.866025404*(ly1-128);
        ny1 = 128 + 0.866025404*(lx1-128) + 0.5*(ly1-128);
        nx2 = 128 + 0.5*(lx2-128) - 0.866025404*(ly2-128);
        ny2 = 128 + 0.866025404*(lx2-128) + 0.5*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        spectrumLine(lspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        if (symmetry==10)
        {
          spectrumLine(lspectrum, 255-nx1, ny1, 255-nx2, ny2);
          spectrumLine(lspectrum, nx1, 255-ny1, nx2, 255-ny2);
        }
        
        nx1 = 128 + 0.5*(rx1-128) - 0.866025404*(ry1-128);
        ny1 = 128 + 0.866025404*(rx1-128) + 0.5*(ry1-128);
        nx2 = 128 + 0.5*(rx2-128) - 0.866025404*(ry2-128);
        ny2 = 128 + 0.866025404*(rx2-128) + 0.5*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        if (symmetry==10)
        {
          spectrumLine(rspectrum, 255-nx1, ny1, 255-nx2, ny2);
          spectrumLine(rspectrum, nx1, 255-ny1, nx2, 255-ny2);
        }
        
        nx1 = 128 + 0.5*(lx1-128) + 0.866025404*(ly1-128);
        ny1 = 128 - 0.866025404*(lx1-128) + 0.5*(ly1-128);
        nx2 = 128 + 0.5*(lx2-128) + 0.866025404*(ly2-128);
        ny2 = 128 - 0.866025404*(lx2-128) + 0.5*(ly2-128);
        spectrumLine(lspectrum, nx1, ny1, nx2, ny2);
        spectrumLine(lspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        if (symmetry==10)
        {
          spectrumLine(lspectrum, 255-nx1, ny1, 255-nx2, ny2);
          spectrumLine(lspectrum, nx1, 255-ny1, nx2, 255-ny2);
        }
        
        nx1 = 128 + 0.5*(rx1-128) + 0.866025404*(ry1-128);
        ny1 = 128 - 0.866025404*(rx1-128) + 0.5*(ry1-128);
        nx2 = 128 + 0.5*(rx2-128) + 0.866025404*(ry2-128);
        ny2 = 128 - 0.866025404*(rx2-128) + 0.5*(ry2-128);
        spectrumLine(rspectrum, nx1, ny1, nx2, ny2);
        spectrumLine(rspectrum, 255-nx1, 255-ny1, 255-nx2, 255-ny2);
        if (symmetry==10)
        {
          spectrumLine(rspectrum, 255-nx1, ny1, 255-nx2, ny2);
          spectrumLine(rspectrum, nx1, 255-ny1, nx2, 255-ny2);
        }
      }
    }
    
  }
}
