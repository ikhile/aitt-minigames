class DrawPage extends Page {
  boolean showStartOverlay;
  int startOverlayMargin = 200;  
  RectTextBtn start = new RectTextBtn("Start", width / 2, height - startOverlayMargin - 50, 100, 50); 
  
  Rectangle faces[];
  Rectangle face;
  Rectangle noses[];
  Rectangle nose;
  ArrayList<int[]> drawnPixels;
  //ArrayList<color> drawnColours;
  
  DrawPage() {
      usesFlow = false;
  }
  
  void launch() {
    showStartOverlay = false;
    drawnPixels = new ArrayList<int[]>();
    
  }
  
  void draw() {
    background(255);
    rectMode(CORNER);
    for(int[] p : drawnPixels) {
      printArray(p);
    }
    
    cam.read();
    opencv.loadImage((PImage)cam);
    drawWebcamMirrored();
    
    face = null;
    nose = null; // unsure if I need these.. decide later
    opencv.setROI(0, 0, width, height);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = opencv.detect();

    for (Rectangle f: faces) {
      opencv.setROI(f.x, f.y, f.width, f.height);
      opencv.loadCascade(OpenCV.CASCADE_NOSE);
      noses = opencv.detect();
      
      if (noses.length > 0) {
        face = f;
        nose = noses[0];
        break;
      }
    }
    
    pushMatrix();
    scale(-1, 1);
    
      if (nose != null) {
        noFill(); stroke(255, 0, 0);
        rect(face.x - width, face.y, face.width, face.height);
        stroke(0, 255, 0);
        rect(nose.x - width + face.x, nose.y + face.y, nose.width, nose.height);
        
        int noseCentreX = nose.x - width + face.x + nose.width / 2;
        int noseCentreY = nose.y + face.y + nose.height / 2;
        int arr[] = {noseCentreX, noseCentreY};
        
        drawnPixels.add(arr);
        circle(noseCentreX, noseCentreY, 5);
      }
      
      // dots are too spaced out
      for(int[] pixel : drawnPixels) {
        fill(0); noStroke();
        circle(pixel[0], pixel[1], 5);
      }
      
      // works but it's not great, 
      for (int i = 0; i < drawnPixels.size() - 1; i++) {
        int[] p1 = drawnPixels.get(i); 
        int[] p2 = drawnPixels.get(i + 1);
        
        stroke(0); line(p1[0], p1[1], p2[0], p2[1]);
      }
    
    popMatrix();

    if (showStartOverlay) {
      background(255);
      noStroke(); fill(0, 0, 0, 100); rectMode(CENTER);
      rect(width / 2, height / 2, width, height);
      fill(255); stroke(0);
      rect(width / 2, height / 2, width - startOverlayMargin, height - startOverlayMargin);
      fill(0);
      text("how to", width / 2, height / 2);
      
      start.draw();
    }
  }
  
  void mousePressed() {
    if (start.mouseOver()) { showStartOverlay = false; background(255); }
  }
}
