class Pong extends Page {
  int p1Score;
  int p2Score;
  boolean started;
  
  PongPlayer p1, p2;
  
  boolean timeout;
  int timeoutLength;
  int millisAtTimeout;
  
  Rectangle faces[];
  Rectangle p1Face;
  Rectangle p2Face;
  
  // court
  int courtX = 200;
  int courtY = 120;
  int courtWidth, courtHeight;
  
  Pong() {
    courtWidth = width - courtX * 2;
    courtHeight = height - courtY * 2;
    p1 = new PongPlayer(1);
    p2 = new PongPlayer(2);
  }
  
  void launch() {
    p1Score = 0;
    p2Score = 0;
    started = true; // change later
    timeout = false;
    millisAtTimeout = 0; // idk // actually might not need to do that at all
    p1.setPos(0, courtHeight / 2);
    p2.setPos(courtWidth, courtHeight / 2);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }

  void draw() { // pong has no end really but could do first to 10?
    background(0);
    
    cam.read();
    opencv.loadImage((PImage)cam); 
    faces = opencv.detect();
    drawWebcamMirrored();
    p1Face = null;
    p2Face = null;
    
    // check which side of the screen each face is on and store as relevant player
    for (int i = 0; i < faces.length && p1Face == null && p2Face == null; i++) { // end loop once both player faces set
      if (p1Face == null && faces[i].x + faces[i].width / 2 > width / 2) { // face on left - greater than because mirrored
        p1Face = faces[i];
        
      } else if (p2Face == null && faces[i].x + faces[i].width / 2 < width / 2) { // face on right - less than because mirrored
        p2Face = faces[i];
      }
      
      if (p1Face != null) println(p1Face.x);
      if (p2Face != null) println("2 " + p2Face.x);
    }
    
    // black transparent "background" over webcam image
    rectMode(CORNER);
    fill(0, 0, 0, 170);
    rect(0, 0, width, height);
    
    pushMatrix();
    scale(-1, 1);
      noFill();
      // draw player 1 red, player 2 blue
      if (p1Face != null) {stroke(255, 0, 0); rect(p1Face.x - width, p1Face.y, p1Face.width, p1Face.height);}
      if (p2Face != null) {stroke(0, 0, 255); rect(p2Face.x - width, p2Face.y, p2Face.width, p2Face.height);}
    popMatrix();
    
    
    // draw pong court
    rectMode(CORNER);
    stroke(255); strokeWeight(4); noFill();
    rect(courtX, courtY, courtWidth, courtHeight);
    line(width / 2, courtY, width / 2, height - courtY);
    
    // scores
    textAlign(CENTER, CENTER);
    text(p1Score, courtX + courtWidth / 4, courtY + 10);
    text(p2Score, courtX + courtWidth * .75, courtY + 10);
    
    
    // players - need to move to faceY first
    p1.draw();
    p2.draw();
    
  }
  
  void mousePressed() {
    
  }
}

class PongPlayer {
  int x, y, absX, absY;
  int h = 120;
  int w = 25;
  int playerNum;
  
  PongPlayer(int playerNum) {
    this.playerNum = playerNum;
  }
  
  void draw() {
    rectMode(CENTER); fill(255); noStroke();
    switch(playerNum) {
      case 1:
       rect(absX + w / 2, absY, w, h);
       break;
     case 2:
       rect(absX - w / 2, absY, w, h);
       break;
    }
  }
  
  void setPos(int x, int y) {
    this.x = x;
    this.y = constrain(y, h / 2, pong.courtHeight - h / 2);
    setAbsPos();
  }
  
  void setYPos(int y) {
    this.y = constrain(y, h / 2, pong.courtHeight - h / 2);
    setAbsPos();
  }
  
  void setAbsPos() {
    absX = pong.courtX + x;
    absY = pong.courtY + y;
  }
}

class Ball {
  int x, y, xSpeed, ySpeed;
  
  void reset() {
    x = width / 2;
    y = pong.courtY;
    
  }
}
