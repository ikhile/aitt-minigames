class StartPage extends Page {
  StartPage() {
      usesFlow = true;
  }
  
  RectTextBtn startBtn = new RectTextBtn("START", width / 2, height / 2, 200, 200, 25);
  void draw() {
    background(100);
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
    setPage(homePage);
  }
}
