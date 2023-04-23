void initCamera(float w, float h)
{
  String[] cameras = Capture.list();
  if (cameras.length != 0) 
  {
    println("Using camera: " + cameras[0]); 
    cam = new Capture(this, int(w), int(h), cameras[0]);
    cam.start();    
    
    while(!cam.available()) print();
    
    cam.read();
    cam.loadPixels();
  }
  else
  {
    println("There are no cameras available for capture.");
    exit();
  }
}

void drawWebcamMirrored() {
  pushMatrix();
  scale(-1, 1);  
    imageMode(CORNER);
    image(opencv.getInput(), -width, 0);
  popMatrix();
}

void drawWebcamMirrored(int x, int y, int w, int h) {
  pushMatrix();
  scale(-1, 1);
    imageMode(CORNER);
    image(opencv.getInput(), -w - x, y, w, h);
  popMatrix();
}

void drawRectMirrored(Rectangle rect) {
  pushMatrix();
  scale(-1, 1);
    rectMode(CORNER); rect(rect.x - width, rect.y, rect.width, rect.height);
  popMatrix();
}
