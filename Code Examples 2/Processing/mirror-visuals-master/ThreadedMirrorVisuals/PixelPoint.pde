class PixelPoint
{
  float x, y;
  float dx, dy;
  
  PixelPoint(float nx, float ny, float ndx, float ndy)
  {
    x = nx;
    y = ny;
    dx = ndx;
    dy = ndy;
  }
  
  void move()
  {
    x += dx;
    y += dy;
  }
  
  void checkMirror(MirrorWall theMirror)
  {
    if (theMirror == null)
      return;
      
    float xp, yp, dxp, dyp;
    float st, ct;
    
    st = sin(theMirror.theta);
    ct = cos(theMirror.theta);
    
    //rotate into the mirror's reference frame.
    //theta = 0 puts the mirror parallel to and above the X axis.
    //theta is measured deosil. (clockwise.)
    xp = ct*x + st*y;
    yp = ct*y - st*x;
    dxp = ct*dx + st*dy;
    dyp = ct*dy - st*dx;
    
    //Now, let's make sure we haven't strayed too far from home...
    if (yp > theMirror.distance)
    {
      //we have. Time to pause and reflect.
      yp = theMirror.distance*2 - yp;
      dyp = -dyp;
       
      //finally, "de-rotate" back into the normal coordinate frame.
      x = ct*xp - st*yp;
      y = ct*yp + st*xp;
      dx = ct*dxp - st*dyp;
      dy = ct*dyp + st*dxp;
    }
  }
    
}

class MirrorWall
{
  float distance, theta;
  
  
  MirrorWall(float d, float t)
  {
    distance = d;
    theta = t;
  }
}
