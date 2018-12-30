#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    //ofSetFrameRate(30);
    
    ofSetWindowShape(WIDTH, HEIGHT);
    ofEnableAntiAliasing();
    ofBackground(0, 0, 0);
    
    //convert to c++
    //colorMode(HSB, TWO_PI, 100, 100, 100);
    calcTheLevels();
    
    pots = {512, 512, 512, 512, 512, 512, 512, 512};
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
    auto currentLevel = levels.at(levels.size() - 1);
    
    //readPotValues();
    
    //mainColor.setHsb(TWO_PI*pots[2], 100*pots[1], 100*pots[0]);
    //backgroundColor.setHsb(TWO_PI*pots[6], 100*pots[7], ofMap(pots[0], 1, 0, 0, 100), 100*pots[5]);
    
    
    mainColor.setHsb(255, 255, 255);
//    backgroundColor.setHsb(0, 0, 0);
    
//    ofSetColor(backgroundColor);
//    ofFill();
//    ofDrawRectangle(0, 0, WIDTH, HEIGHT);
    
    circleDiameter = ofMap(pots[4], 0, 1, minDiameter, maxDiameter);
    
    for (int j = 0; j < currentLevel.size(); j++) {
        // draw the circles
        ofNoFill();
        ofSetColor(mainColor);
        ofDrawCircle(currentLevel[j].x, currentLevel[j].y, 160);
        
        //draw the arches
        ofSetColor(mainColor);
        ofNoFill();

        int halfPoint = numberOfRadiusPoints/2;
        float startAngle, stopAngle;
        if (numberOfRadiusPoints % 2 == 0) { //for even number of points

            startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j);
            stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint+1-j)+angleInRadians;

            ofPolyline curve;
            curve.arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle);

            startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
            stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;
            curve.arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle);

            curve.draw();
        }
        else {
            ofPolyline curve;

            startAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j);
            stopAngle = -angleInRadians*(numberOfRadiusPoints-halfPoint-j)+angleInRadians;

            curve.arc(currentLevel[j].x, currentLevel[j].y, circleDiameter, circleDiameter, startAngle, stopAngle);

            curve.draw();
        }
    }// for all elements on this level
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    
//     switch (key){
//     case '1':
//     bUsingMesh = false;
//     model.loadModel("penguin.dae");
//     model.setRotation(0, 180, 1, 0, 0);
//     model.setScale(0.9, 0.9, 0.9);
//     cam.setDistance(700);
//     curFileInfo = ".dae";
//     break;
//     case '2':
//     bUsingMesh = false;
//     model.loadModel("penguin.3ds");
//     model.setRotation(0, 180, 1, 0, 0);
//     model.setScale(0.9, 0.9, 0.9);
//     cam.setDistance(700);
//     curFileInfo = ".3ds";
//     break;
//     case '3':
//     bUsingMesh = false;
//     model.loadModel("penguin.ply");
//     model.setRotation(0, 90, 1, 0, 0);
//     model.setScale(0.9, 0.9, 0.9);
//     cam.setDistance(700);
//     curFileInfo = ".ply";
//     break;
//     case '4':
//     bUsingMesh = false;
//     model.loadModel("penguin.obj");
//     model.setRotation(0, 90, 1, 0, 0);
//     model.setScale(0.9, 0.9, 0.9);
//     cam.setDistance(700);
//     curFileInfo = ".obj";
//     break;
//     case '5':
//     bUsingMesh = false;
//     model.loadModel("penguin.stl");
//     model.setRotation(0, 90, 1, 0, 0);
//     model.setScale(0.9, 0.9, 0.9);
//     cam.setDistance(700);
//     curFileInfo = ".stl";
//     break;
//     case '6':
//     bUsingMesh = true;
//     cam.setDistance(40);
//     curFileInfo = ".ply loaded directly into ofmesh";
//     break;
//     case 'h':
//     //toggle help text
//     bHelpText = !bHelpText;
//     break;
//     default:
//     break;
//     }
//
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

void ofApp::calcTheLevels(){
    levels.clear();
    for (int i = 0; i <= numberOfLevels; i++) {
        int numOfElements = pow(numberOfRadiusPoints, i);
        vector<ofVec2f> level(numOfElements);
        levels.push_back(level);
    }
    
    for (int i = 0; i <= numberOfLevels; i++) {
        auto currentLevel = levels.at(i);
        
        for (int j = 0; j < currentLevel.size(); j++) {
            if (i != 0) {
                auto previousLevel = levels.at(i-1);
                centerPoint = previousLevel[floor(j/numberOfRadiusPoints)];
                float pointX = centerPoint.x + cos(angleInRadians*j)*circleRadius;
                float pointY = centerPoint.y + sin(angleInRadians*j)*circleRadius;
                std::cout << pointX << std::endl;
                std::cout << pointY << std::endl;
                // currentLevel[j] = new PVector(pointX, pointY);
                currentLevel[j] = ofVec2f(pointX, pointY);
            } else {
                currentLevel[j] = ofVec2f(WIDTH/2, HEIGHT/2);
            }
            std::cout << currentLevel[j].x << std::endl;
            std::cout << currentLevel[j].y << std::endl;
        }
        
        levels[i] = currentLevel;
    }
    
    // calc min and max diamater
    ofVec2f zeroPoint = ofVec2f(centerPoint.x+(cos(0)*circleRadius), centerPoint.y+(sin(0)*circleRadius));
    ofVec2f anglePoint = ofVec2f(centerPoint.x+(cos(angleInRadians)*circleRadius), centerPoint.y+(sin(angleInRadians)*circleRadius));
    
    float archHeight = circleRadius - (cos(angleInRadians/2)*circleRadius);
    
    minDiameter = zeroPoint.distance(anglePoint) + archHeight;
}
