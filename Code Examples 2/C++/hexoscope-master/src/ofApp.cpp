#include "ofApp.h"

//#define X_OFFSET -70
//#define Y_OFFSET -70

//--------------------------------------------------------------
void ofApp::setup(){
    bScreenshot = false;
    string myFile = "frames/tri-"+ofToString(curFile,0,4,'0')+".png";
    img.loadImage(myFile);
    
    // GUI Stuff
    // we add this listener before setting up so the initial circle resolution is correct
    
    gui.setup(); // most of the time you don't need a name
    
    //gui.add(filled.setup("fill", true));
    //gui.add(radius.setup( "radius", 140, 10, 300 ));
    //gui.add(center.setup("center",ofVec2f(ofGetWidth()*.5,ofGetHeight()*.5),ofVec2f(0,0),ofVec2f(ofGetWidth(),ofGetHeight())));
    //gui.add(color.setup("color",ofColor(100,100,140),ofColor(0,0),ofColor(255,255)));
    
    gui.add(xOffset.setup("x offset", -312.0f, -1080.0f, 0.0f));
    gui.add(yOffset.setup("y offset", -312.0f, -1080.0f, 0.0f));
    
    gui.add(hIterations.setup("h iters", 39, 1, 50));
    gui.add(vIterations.setup("v iters", 27, 1, 50));
    
    gui.add(xMult.setup("xMult",60,39,624));
    gui.add(yMult.setup("yMult",108.0f,100,300));
    
    gui.add(xOff2.setup("xOff2",-62.3f,100,300));
    gui.add(yOff2.setup("yOff2",-72.0f,100,300));
    
gui.add(fudger.setup("fudger",0.994f,0.8f,1.2f));
    
    
    //gui.add(twoCircles.setup("two circles"));
    //gui.add(ringButton.setup("ring"));
    //gui.add(screenSize.setup("screen size", ""));
    
    bHide = true;
    
    
    for(int i=firstFile;i<=lastFile;i++){
        string myFile = "frames/tri-"+ofToString(i,0,4,'0')+".png";
        ofLog() << myFile;
    }
    
}

//--------------------------------------------------------------
void ofApp::update(){
    //actual yMult = floor((float)xMult*0.86538462f);
    yMult = (float)xMult*0.86538462f;
    xOff2 = xMult/-2.0f;
    yOff2 = yMult/-1.5f;
}

//--------------------------------------------------------------
void ofApp::draw(){
    //ofPushMatrix();
    //ofTranslate(ofGetWidth()/2,ofGetHeight()/2);
    //img.draw(-124.8/2,-108/2,124.8,-108);
    //ofPopMatrix();
    ofBackground(212);
    ofPushMatrix();
    ofTranslate(0,108);
    
    //float xMult = 124.8f;
    //float yMult = 108.0f;
    
    //float xOff2 = -62.3f;
    //float yOff2 = -72.0f;
    
    
    for(int j=0;j<vIterations;j++){
        
        for(int i=0;i<hIterations;i++){
            ofPushMatrix();
            ofTranslate(i*xMult*fudger+(j%2)*xMult*fudger/2+xOffset,j*yMult*fudger+yOffset);
            ofPushMatrix();
            ofRotate(i*-240+(j%2)*240);
            //ofSetColor(255,0,0);
            img.draw(xOff2,yOff2,xMult,yMult);
            ofPopMatrix();
           // ofRect(0,0,3,3);
            ofTranslate(xMult*fudger/2,yOff2*fudger/2);
            ofRotate(-240+i*-120+j%2*-240);
            //ofSetColor(0,0,255);
            //if(j==0){
                img.draw(xOff2,-1*yOff2,xMult,-1*yMult);
              //  ofRect(0,0,3,3);
               // ofDrawBitmapString(ofToString(i)+","+ofToString(j),0,0);

            //}
                        ofPopMatrix();
        }
        
        
    }
    
    
    ofPopMatrix();
    
    if(bScreenshot){
        xMult=xMult+0.1f;
        yOffset=yOffset-2.0f;
        xOffset=xOffset-(2.0f*1.73076924f);
        //color = ofColor(255);
        curFile++;
        if(curFile>lastFile){
            curFile = firstFile;
        }
        
        string myFile = "frames/tri-"+ofToString(curFile,0,4,'0')+".png";
        img.loadImage(myFile);
    string myFile2 = "output-"+ofToString(outputFile++,0,4,'0')+".png";
    ofImage screenImg;
    screenImg.allocate(ofGetScreenWidth(), ofGetScreenHeight(), OF_IMAGE_COLOR);
    screenImg.grabScreen(0,0,1920,1080);
    screenImg.saveImage(myFile2);
      // bScreenshot = false;
    }
    // auto draw?
    // should the gui control hiding?
    if( bHide ){
        gui.draw();
    }
    
}

void ofApp::circleResolutionChanged(int & circleResolution){
    ofSetCircleResolution(circleResolution);
}

void ofApp::ringButtonPressed(){
    ring.play();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if( key == 'h' ){
        bHide = !bHide;
    }
    if(key == 's') {
        gui.saveToFile("settings.xml");
    }
    if(key == 'l') {
        gui.loadFromFile("settings.xml");
    }
    if(key == ' '){


        bScreenshot = true;
        /*
        string myFile2 = "output-"+ofToString(outputFile++,0,4,'0')+".png";
        ofImage screenImg;
        screenImg.allocate(ofGetScreenWidth(), ofGetScreenHeight(), OF_IMAGE_COLOR);
        screenImg.grabScreen(0,0,1920,1080);
        screenImg.saveImage(myFile2);
        */
    }
    
    if(key == 'i'){
        ofImage screenImg;
        screenImg.allocate(ofGetScreenWidth(), ofGetScreenHeight(), OF_IMAGE_COLOR);
        screenImg.grabScreen(0,0,1920,1080);
        screenImg.saveImage("screenshot.png");
    }
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
void ofApp::windowResized(int w, int h){
    screenSize = ofToString(w) + "x" + ofToString(h);

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 
    
}
