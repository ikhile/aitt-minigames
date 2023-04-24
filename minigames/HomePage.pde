class HomePage extends Page {
  RectTextBtn startBtn = new RectTextBtn("Start", width / 2, height * 5 / 6, 150, 50);  
  CircleTextBtn leftBtn = new CircleTextBtn(Character.toString(0x2190), width * .2, height / 2, 80);
  CircleTextBtn rightBtn = new CircleTextBtn(Character.toString(0x2192), width * .8, height / 2, 80);
    
  int gameIndex = 0;
  String[] gameTitles = {"Pong", "Flappy Bird", "Quiz", "Dodge"};
  String[] gameImagePaths = {"pong.png", "fb.png", "quiz.png", "dodge.png"};
  Page[] gamePages = {pong, fbi, quiz, dodge};
  PImage[] gameImages;
  
  boolean showOverlay = false;
  boolean showHelpOverlay = false;
  boolean showSettingsOverlay = false;
    
  HomePage() {
    usesFlow = true;
    gameIndex = int(random(gameTitles.length));
    
    gameImages = new PImage[gameImagePaths.length];
    for (int i = 0; i < gameImagePaths.length; i++) {
      gameImages[i] = loadImage(gameImagePaths[i]);
    }
    
    leftBtn.setStrokeWeight(3); leftBtn.setColours(color(255, 255, 255, 50), color(255), color(255)); leftBtn.setFontSize(48);
    rightBtn.setStrokeWeight(3); rightBtn.setColours(color(255, 255, 255, 50), color(255), color(255)); rightBtn.setFontSize(48);
    
  }
  
  void draw() {
    background(255);
    
    rectMode(CORNER); noStroke(); fill(0, 0, 255, 100); rect(0, 0, width, height);
    
    // game info
    textAlign(CENTER, CENTER);
    textSize(48); fill(255); text(gameTitles[gameIndex], width / 2, height / 6);
    imageMode(CENTER);
    image(gameImages[gameIndex], width / 2, height / 2, width / 2, height / 2);
    
    // lil webcam inlay
    drawWebcamMirrored(20, 20, 192, 108);
    rectMode(CORNER); strokeWeight(3); stroke(255, 0, 255); noFill(); rect(20, 20, 192, 108);
    
    // buttons
    leftBtn.draw();
    rightBtn.draw();
    startBtn.draw();
  }
  
  void mousePressed() {
    if (showOverlay) {
      showOverlay = false;
      showHelpOverlay = false;
      showSettingsOverlay = false;
    }
    
    else if (leftBtn.mouseOver()) {
      leftArrow();
    }
    
    else if (rightBtn.mouseOver()) {
      rightArrow();
    
    } else if (startBtn.mouseOver()) {
      setPage(gamePages[gameIndex]);
    }
  }
  
  void keyPressed() {
    if (showOverlay) {
      showOverlay = false;
      showHelpOverlay = false;
      showSettingsOverlay = false;
    }
    
    else if (key == CODED) {
      
      switch (keyCode) {
        case LEFT:
          leftArrow();
          break;
          
        case RIGHT:
          rightArrow();
          break;
      }
    }
  }
  
  void flowLeft() { leftArrow(); }
  void flowRight() { rightArrow(); }
  void flowUp() {}
  void flowDown() {}
  
  void leftArrow() {
    scrollGames(false);
  }
  
  void rightArrow() {
    scrollGames(true);
  }
  
  void scrollGames(boolean next) {
    gameIndex = next ? gameIndex + 1 : gameIndex - 1;
    
    if (gameIndex >= gameTitles.length) gameIndex = 0;
    else if (gameIndex < 0) gameIndex = gameTitles.length - 1;
  }
}
