class HomePage extends Page {
  // buttons
  RectTextButton startBtn = new RectTextButton("Start", width / 2, height - 70, 150, 50);
  RectTextButton helpBtn = new RectTextButton("?", width - 35, 35, 50, 50, 15);
  RectTextButton settingsBtn = new RectTextButton("Settings", width - 120, 35, 100, 50);
  RectTextButton leaderboardBtn = new RectTextButton("Leaderboard", width - 230, 35, 100, 50);
  
  CircleTextButton leftBtn = new CircleTextButton("<", width * .2, height / 2, 50);
  CircleTextButton rightBtn = new CircleTextButton(">", width * .8, height / 2, 50);
    
  // game menu item might be a class with an image button to start the game, a title and description text
  // or simply three arrays and an index
  int gameIndex = 0;
  String[] gameTitles = {"1", "2", "3"};
  String[] gameImagePaths = {"placeholder.png", "placeholder.png", "placeholder.png"};
  String[] gameDescriptions = {"1", "2", "3"};
  PImage[] gameImages;
  
  boolean showOverlay = false;
  boolean showHelpOverlay = false;
  boolean showSettingsOverlay = false;
  
  //boolean opticalFlowControls;
  
  HomePage() {
    usesFlow = true;
    //opticalFlowControls = usesFlow;
    //startBtn.setFontSize(24);
    
    gameImages = new PImage[gameImagePaths.length];
    for (int i = 0; i < gameImagePaths.length; i++) {
      gameImages[i] = loadImage(gameImagePaths[i]);
    }
    
  }
  
  void draw() {
    background(155);
    
    // game info
    pushMatrix();
    translate(0, -30); // shifted up a bit for start button
      text(gameTitles[gameIndex], width / 2, 100);
      text(gameDescriptions[gameIndex], width / 2, height - 100, width, height / 5);
      imageMode(CENTER);
      image(gameImages[gameIndex], width / 2, height / 2, width / 2, height / 2);
    popMatrix();
    
    // lil webcam inlay
    drawWebcamMirrored(20, 20, 160, 90);
    // webcam border
    strokeWeight(3); stroke(255, 0, 0); noFill(); rectMode(CORNER);
    rect(20, 20, 160, 90);
    
    // render buttons
    leftBtn.draw();
    rightBtn.draw();
    startBtn.draw();
    helpBtn.draw();
    settingsBtn.draw();
    leaderboardBtn.draw();
    
    if (showOverlay) {
      fill(0, 0, 0, 150);
      noStroke();
      rectMode(CORNER);
      rect(0, 0, width, height);
      
      rectMode(CENTER);
      fill(255);
      stroke(0);
      rect(width / 2, height / 2, width * .8, height * .8);
      text("Click anywhere or press any key to exit", width / 2, height * .95);
      
      if (showHelpOverlay) {
        fill(0);
        text("instructions", width / 2, height / 2, width * .7, height * .7);
      } else if (showSettingsOverlay) {
        
        fill(0);
        text("settings", width / 2, height / 2, width * .7, height * .7);
      }

    }
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
    }
    
    else if (helpBtn.mouseOver()) {
      showOverlay = true;
      showHelpOverlay = true;
    }
    
    else if (settingsBtn.mouseOver()) {
      showOverlay = true;
      showSettingsOverlay = true;
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
    println("functionality for moving/clicking/pressing left");
    scrollGames(false);
  }
  
  void rightArrow() {
    println("functionality for moving/clicking/pressing right");
    scrollGames(true);
  }
  
  void scrollGames(boolean next) {
    gameIndex = next ? gameIndex + 1 : gameIndex - 1;
    
    // this could be a nice lil global function later
    if (gameIndex >= gameTitles.length) gameIndex = 0;
    else if (gameIndex < 0) gameIndex = gameTitles.length - 1;
    
    println(gameIndex);
  }
}
