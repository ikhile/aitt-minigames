import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;
import java.util.*;

// Pages
Page currentPage;
StartPage startPage;
HomePage home;
FlappyBirdIntro fbi;
FlappyBird fb;
FlappyBird2Player fb2;
Pong pong;
Quiz4 quiz4;
Dodge dodge;


// OpenCV
OpenCV opencv;
Capture cam;

int numGames = 5;

JSONObject data;
String dataPath = "data/data.json";

void setup() {
  //fullScreen();
  size (1536, 864);
  
  // OpenCV and Camera
  initCamera(width, height);
  opencv = new OpenCV(this, cam.width, cam.height);
  surface.setResizable(true); // needed?
  
  data = loadJSONObject(dataPath);
  fbi = new FlappyBirdIntro();
  fb = new FlappyBird();
  fb2 = new FlappyBird2Player();
  pong = new Pong();
  quiz4 = new Quiz4();
  dodge = new Dodge();
  startPage = new StartPage();
  
  home = new HomePage();
  setPage(dodge);
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

void setPage(Page page) {
  currentPage = page;
  currentPage.launch();
}

void dottedLine(float x1, float y1, float x2, float y2, int dotSize, float num) {
  
  // after trying my own method (below) this was adapted from the Processing reference https://processing.org/reference/lerp_.html
  for (int i = 0; i <= num; i++) {
    float x = lerp(x1, x2, i / num);
    float y = lerp(y1, y2, i / num);
    circle(x, y, dotSize);
  }
    
  //float currentX = x1;
  //float currentY = y1;
  
  //while (currentX <= x1 && currentY <= y1) {
  //  println(currentX);
  //  circle(currentX, currentY, dotSize);
  //  currentX = lerp(x1, x2, 0.05);
  //  currentY = lerp(y1, y2, 0.05);
  //}
}
