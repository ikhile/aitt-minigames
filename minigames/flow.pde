float flowSensitivityX = 0.5; // how much movement must be registered for an actual movement to be detected
float flowSensitivityY = 0.15;
float pauseSeconds = 0.5; // how long to pause between detecting a movement and detecting the next one
int millisAtPause;
boolean flowPaused = false;

void getFlowDirection() {
  if (!flowPaused) {
    if (cam.available()) {    
      cam.read();
      opencv.loadImage((PImage)cam);    
      opencv.calculateOpticalFlow();
  
      if (opencv.getAverageFlow().x < -flowSensitivityX) {
        flowRight();
        flowPause();
      }
      
      else if (opencv.getAverageFlow().x > flowSensitivityX) {
        flowLeft();
        flowPause();
      }
      
      if (opencv.getAverageFlow().y < -flowSensitivityY) {
        flowUp();
        flowPause();
      }
      
      else if (opencv.getAverageFlow().y > flowSensitivityY) {
        flowDown();
        flowPause();
      }
    }
  } else {
    if (millis() - millisAtPause >= pauseSeconds * 1000) { flowPaused = false;  }
  }
}

void flowPause() {
  millisAtPause = millis();
  flowPaused = true;
}

void flowLeft() {
   currentPage.flowLeft();
}

void flowRight() {
   currentPage.flowRight();
}

void flowUp() {
  println("flow up");
  // currentPage.flowUp();
}

void flowDown() {
  println("flow down");
  // currentPage.flowDown();
}
