import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

// Pages
Page currentPage;
StartPage startPage;
HomePage homePage;
FlappyBirdIntro fbi;
FlappyBird fb;
DrawPage drawPage;

// OpenCV
OpenCV opencv;
Capture cam;

int numGames = 5;

JSONObject data;
String dataPath = "data/data.json";

// settings

void setup() {
  //fullScreen();
  size (1536, 864);
  
  data = loadJSONObject(dataPath);
  startPage = new StartPage();
  homePage = new HomePage();
  fbi = new FlappyBirdIntro();
  fb = new FlappyBird();
  drawPage = new DrawPage();
  setPage(drawPage);
  
  // OpenCV and Camera
  initCamera(width, height);
  opencv = new OpenCV(this, cam.width, cam.height);
  surface.setResizable(true); // needed?
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

// this can def be done i just cba right now
//void dottedLine(int x1, int y1, int x2, int y2, int length, int gap) {
  
//}
