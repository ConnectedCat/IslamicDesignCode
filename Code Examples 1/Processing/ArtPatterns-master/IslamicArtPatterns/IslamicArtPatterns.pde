/**
 * For so long I've been fascinated by Islamic Art patterns
 * and their geometrical complexity, not to mention the complexity
 * attached to replicating and animating them.
 *
 * This project is a naive attempt at replicating some Art patterns 
 * and animating them in interesting ways.
 *
 * This is a work in progress.
 * 
 * @author: 	Bassem Dghaidy
 * @website: 	http://bassemdy.com
 * @version:	0.11
 * @license:	...
 */


///////////////////////////////////////
// Non Portable Code to ProcessingJS //
///////////////////////////////////////

import controlP5.*;

ControlP5 cp5;

float controlOuterRadius = 0.8;						// Outer Radius Value
float controlInnerRadius = 0.4;						// Inner Radius Value
float controlPts         = 5.0;						// Number of points for the shape
float controlAngle       = 0.0;						// Angle of rotation


public void controlEvent(ControlEvent theEvent) 
{
  switch(theEvent.getId()) 
  {
    case(1): 
	controlAngle       = (theEvent.getController().getValue());
	break;
		
	case(2):  
	controlOuterRadius = (theEvent.getController().getValue());
	break;
		
	case(3):
	controlInnerRadius = (theEvent.getController().getValue());
	break;
		
	case(4):
	controlPts         = (theEvent.getController().getValue());
    break;
  }
}

/// >> END

/**
 * The entierty of the code is dirty and not 
 * commented. But it will be done later. (promise)
 */

// ArrayList containing TriangloPods 
// for the animation
ArrayList trList;

// Noise timer
float timeVar       = 0.0;

// Controlling variables
float keyPoints		= 0.0;
float outerMulti	= 0.8;
float innerMulti	= 0.4;

//////////////////
// Setup Method //
//////////////////
void setup()
{
	// Initial Configuration
	size(1024, 768);
	background(203);
	smooth();

	// Set the framerate to smooth
	// the animation
	frameRate(25);

	// Create the initial TriangloPod list
	trList = new ArrayList();
	for (int i = 0; i < 10; i++)
	{
		// x, y, angle position, points, outer radius, inner radius
		// middle, middle, shift angle by a certain variable, points, initial vars
		trList.add(new TriangloPod(width/2, height/2, i*5, 4, 0.5, 0.5));
	}


	///////////////////////////////////////
	// Non Portable Code to ProcessingJS //
	///////////////////////////////////////
	
	cp5 = new ControlP5(this);

	// Adding the control sliders
	// name, minValue, maxValue, defaultValue, x, y, width, height
  	cp5.addSlider("angleSlider", 0, 180, 90, 10, 10, 100, 14).setId(1);
  	cp5.addSlider("outerRadius", 0, 1, 0.5, 10, 26, 100, 14).setId(2);
  	cp5.addSlider("innerRadius", 0, 1, 0.5, 10, 42, 100, 14).setId(3);
  	cp5.addSlider("points", 0, 100, 5, 10, 58, 100, 14).setId(4);

  	/// >> END
}

////////////////
// Main Loop  //
////////////////
void draw() 
{
	// Always reset the background
	// to clear out previous frames
	background(203);

	// Reset the stroke color / weight and fill color
	stroke(255);
	strokeWeight(1);
	noFill();

	// Drawing proceedure
	float n  		= noise(timeVar);

	float tmpAngle 	= map(n, 0, 1, 0, 180);
	float tmpOR		= map(n, 0, 1, 0.5, 0.8);
	float tmpIR		= map(n, 0, 1, 0.5, 0.8);
	float tmpPts	= map(n, 0, 1, 1, 50);

	// println(tmpOR);

	// Update each element of the Trianglopods list
	for (int i = 0; i < trList.size(); i++)
	{
		TriangloPod xP = (TriangloPod) trList.get(i);

		// xP.setAngle(tmpAngle * i / 10);
		// xP.setOuterRad(tmpOR * outerMulti);
		// xP.setInnerRad(tmpIR * innerMulti, false);

		////////////////////////////
		// Non Portable Updates //
		////////////////////////////
		xP.setAngle(controlAngle * (i + 1));
		xP.setOuterRad(controlOuterRadius);
		xP.setInnerRad(controlInnerRadius, false);
		xP.setPoints(controlPts);

		/// >> END

		// Extra control
		// if (keyPoints > 0.0)
			// xP.setPoints(keyPoints);

		xP.update();
	}

	timeVar += 0.005;
}


////////////////////
// Keyboard Input //
////////////////////
void keyPressed()
{
	switch(key)
	{
		// Increase the number of points
		case 'p':
			if (keyPoints < 50)
				keyPoints++;
		break;

		// Decrease points
		case 'l':
			if (keyPoints > 0)
				keyPoints--;
		break;

		case 'o':
			outerMulti += 0.01;
		break;

		case 'k':
			outerMulti -= 0.01;
		break;

		case 'i':
			innerMulti += 0.01;
		break;

		case 'j':
			innerMulti -= 0.01;
		break;
	}
}


///////////////////////
// TriangloPod Class //
///////////////////////
class TriangloPod
{
	int x, y;									// Coordinates
	float outerRadius = 0;						// Outer Radius Value
	float innerRadius = 0;						// Inner Radius Value
	float pts         = 0;						// Number of points for the shape
	float angle       = 0;						// Angle of rotation
	float rot 		  = 0;						// Incremental rotation for each shape

	//////////////////
	// Constructor //
	//////////////////
	TriangloPod(int posX, int posY, float angPos, float points, float outR, float innerR)
	{
		x           = posX;
		y           = posY;
		angle       = angPos;
		outerRadius = min(width, height) * outR;
		innerRadius = outerRadius * innerR;
		pts 		= points;
		rot 		= 180.0/pts;
	}

	/////////////////////
	// Setter Methods //
	/////////////////////
	
	// Sets the points of each component of the trianglopod
	public void setPoints(float newVal)
	{
		if (newVal != pts)
		{
			pts = newVal;
			rot = 180.0/pts;
		}
	}

	// Sets the outer radius value
	public void setOuterRad(float newVal)
	{
		outerRadius = min(width, height) * newVal;
	}
	
	// Sets the inner radius value with an option bool 
	// for maintaining relationship with outerradius and avoid
	// overflow behavior
	public void setInnerRad(float newVal, boolean relationship)
	{
		if (relationship)
			// Simply to maintain a relationship and not overflow
			innerRadius = outerRadius * newVal;
		else
			// Optional
			innerRadius = min(width, height) * newVal;
	}

	// Set rotation angle
	public void setAngle(float newVal)
	{
		if (newVal != angle)
			angle = newVal;
	}

	// Set position of trianglopod
	public void setLocation(int newX, int newY)
	{
		if (newX != x)
			x = newX;

		if (newY != y)
			y = newY;
	}


	//////////////////////
	// Drawing Methods //
	//////////////////////
	void update()
	{
		beginShape(TRIANGLE_STRIP);
		for (int i = 0; i <= pts; i++)
		{
			float px = x + cos(radians(angle)) * outerRadius;
			float py = y + sin(radians(angle)) * outerRadius;

			angle    += rot;
			
			// fill(255, 40);

			vertex(px, py);

			px       = x + cos(radians(angle)) * innerRadius;
			py       = y + sin(radians(angle)) * innerRadius;
			
			// fill(0, 80);

			vertex(px, py); 
			
			angle    += rot;
		}
	 	endShape();
	}
}