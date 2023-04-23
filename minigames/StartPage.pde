class StartPage extends Page {
  StartPage() {
      usesFlow = true;
  }
  
  RectTextBtn startBtn = new RectTextBtn("START", width / 2, height * .75, 200, 100, 25);
  
  void draw() {
    background(0);
    textAlign(CENTER, CENTER);
    
    textSize(130); fill(255, 0, 255);
    text("Face Frenzy", width / 2, height / 4);
    
    textSize(72); fill(255);
    text("Get your head in the game", width / 2, height / 2);
    
    startBtn.draw();
  }
  
  void mousePressed() {
    if (startBtn.mouseOver()) {
      start();
    }
  }
  
  void keyPressed() {
    start();
  }
  
  void start() {
    setPage(home);
  }
}
