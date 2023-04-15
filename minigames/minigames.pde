import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

// Pages
Page currentPage;
StartPage startPage;
HomePage homePage;
FlappyBirdIntro fbi;
FlappyBird fb;

// OpenCV
OpenCV opencv;
Capture cam;

int numGames = 5;

JSONObject data;
String dataPath = "data/data.json";

// settings

void setup() {
  //fullScreen();
  size (960, 540);
  
  // Pages
  startPage = new StartPage();
  homePage = new HomePage();
  
  // games
  fbi = new FlappyBirdIntro();
  fb = new FlappyBird();
  currentPage = fb;
  
  // OpenCV and Camera
  initCamera(width, height);
  opencv = new OpenCV(this, cam.width, cam.height);
  surface.setResizable(true);
  
  data = loadJSONObject(dataPath);
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

// this can def be done i just cba right now
//void dottedLine(int x1, int y1, int x2, int y2, int length, int gap) {
  
//}
