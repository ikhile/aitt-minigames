import processing.video.*;
import gab.opencv.*;

// Pages
Page currentPage;
StartPage startPage;
HomePage home;

// OpenCV
OpenCV opencv;
Capture cam;

int numGames = 5;

// settings

void setup() {
  //fullScreen();
  size (960, 540);
  
  // Pages
  startPage = new StartPage();
  home = new HomePage();
  currentPage = home;
  
  // OpenCV and Camera
  initCamera(width, height);
  opencv = new OpenCV(this, cam.width, cam.height);
  surface.setResizable(true);
}

void draw() {
  if (currentPage.usesFlow) getFlowDirection();
  currentPage.draw();
}


void mousePressed() {
  currentPage.mousePressed();
}

void keyPressed() {
  currentPage.keyPressed();
}
