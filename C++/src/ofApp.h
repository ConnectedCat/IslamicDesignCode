#pragma once

#include "ofMain.h"

#define WIDTH 800
#define HEIGHT 600

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
    void calcTheLevels();
		
    
    
    //convert this code to c++
    //ArrayList<PVector[]> levels = new ArrayList<PVector[]>();
    
    vector< vector< ofVec2f > > levels;
    
    ofVec2f centerPoint;
    
    float circleDiameter = 200;
    float minDiameter;
    float maxDiameter = 250;
    float circleRadius = circleDiameter/2;
    
    int minNumRadPoints = 4;
    int maxNumRadPoints = 12;
    int numberOfRadiusPoints = 7;
    
    int numberOfLevels = 2;
    float angleInRadians = TWO_PI/numberOfRadiusPoints;
    
    ofColor mainColor, backgroundColor;
    
    array<int, 8> pots;
    
    //Vector is an array in OF
//    vector<centerPoint> levels = new vector<centerPoint>;
    
};
