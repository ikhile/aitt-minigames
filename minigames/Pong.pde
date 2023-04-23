class Pong extends Page {
  int p1Score;
  int p2Score;
  int winScore = 1;
  boolean started, paused, gameOver;
  
  PongPlayer p1, p2;
  PongBall ball;
  
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
  
  RectTextBtn startBtn = new RectTextBtn("Start", width / 2, height - courtY / 2, 150, 50);
  RectTextBtn pauseBtn = new RectTextBtn("Pause", width / 2, height - courtY / 2, 150, 50);
  
  Pong() {
    courtWidth = width - courtX * 2;
    courtHeight = height - courtY * 2;
    p1 = new PongPlayer(1);
    p2 = new PongPlayer(2);
    ball = new PongBall();
    
    startBtn.setStroke(color(255));
    startBtn.setTextColour(color(255));
    startBtn.setNoFill();
    startBtn.setStrokeWeight(4);
    
    //pauseBtn.setColours(color(0), color(255), color(255));
    pauseBtn.setStroke(color(255));
    pauseBtn.setTextColour(color(255));
    pauseBtn.setNoFill();
    pauseBtn.setStrokeWeight(4);
  }
  
  void launch() {
    p1Score = 0;
    p2Score = 0;
    paused = false;
    started = false;
    gameOver = false;
    timeout = false;
    millisAtTimeout = 0; // idk // actually might not need to do that at all
    p1.setPos(courtY + courtHeight / 2);
    p2.setPos(courtY + courtHeight / 2);
    ball.reset();
    if (ball.xSpeed < 0) ball.xSpeed = -ball.xSpeed;
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }

  void draw() { // pong has no end really but could do first to 10?
    background(0);
    
    if (!started) {
      background(0);
      fill(255);
      rectMode(CENTER);
      textAlign(CENTER, BASELINE);
      text("instructions", width / 2, height / 2);
      
      noFill(); stroke(255); strokeWeight(4);
      rect(width / 2, height / 2, courtWidth, courtHeight);
      p1.draw();
      p2.draw();
      stroke(255, 255, 255, 100); fill(255); noStroke();
      dottedLine(width / 2, courtY + 10, width / 2, height - courtY - 10, 5, 50);
      startBtn.draw();
    }
    
    if (started) {
          // OPEN CV
        cam.read();
        opencv.loadImage((PImage)cam); 
        faces = opencv.detect();
        
        // background: webcam image transparent black
        drawWebcamMirrored();
        // black transparent "background" over webcam image
        rectMode(CORNER); fill(0, 0, 0, 170); rect(0, 0, width, height);
        
        // get faces
        p1Face = null;
        p2Face = null;
        
        // check which side of the screen each face is on and store as relevant player
        for (int i = 0; i < faces.length && p1Face == null && p2Face == null; i++) { // end loop once both player faces set
          if (p1Face == null && faces[i].x + faces[i].width / 2 > width / 2) { // face on left - greater than because mirrored
            p1Face = faces[i];
            
          } else if (p2Face == null && faces[i].x + faces[i].width / 2 < width / 2) { // face on right - less than because mirrored
            p2Face = faces[i];
          }
        }
        
        if (faces.length == 0) {
          textSize(24); fill(255);
          text("No faces detected. Please move into frame or check your lighting.", width / 2, courtY / 2);
        }
        
        // DRAW FACES
        // replace with drawRectMirrored()
        pushMatrix();
        scale(-1, 1);
          noFill();
          // draw player 1 red, player 2 blue
          if (p1Face != null) {stroke(255, 0, 0); rect(p1Face.x - width, p1Face.y, p1Face.width, p1Face.height);}
          if (p2Face != null) {stroke(0, 0, 255); rect(p2Face.x - width, p2Face.y, p2Face.width, p2Face.height);}
        popMatrix();
        
        
        // COURT
        rectMode(CORNER);
        stroke(255); strokeWeight(4); noFill();
        rect(courtX, courtY, courtWidth, courtHeight);
        fill(255); noStroke();
        dottedLine(width / 2, courtY + 10, width / 2, height - courtY - 10, 5, 50);
        
        // SHOW SCORES
        fill(255); textAlign(CENTER, CENTER); textSize(50);
        text(p1Score, courtX + courtWidth / 4, courtY + 30);
        text(p2Score, courtX + courtWidth * .75, courtY + 30);
        
        // PLAYER
        if (p1Face != null) p1.setY(p1Face.y + p1Face.height / 2);
        if (p2Face != null) p2.setY(p2Face.y + p2Face.height / 2);
        p1.draw();
        p2.draw();
        
        // BALL
        ball.move();
        ball.draw();
        
        if (ball.hitUDWall()) {
          ball.ySpeed = -ball.ySpeed;
        }
        
        if (ball.hitPlayer()) {
          ball.xSpeed = -ball.xSpeed;
        }
        
        if (ball.hitLWall()) {
          // p2 score
          println("p2 score");
          p2Score++;
          ball.reset();
          
          if (p2Score == winScore) {
            println("p2 wins");
          }
        }
        
        if (ball.hitRWall()) {
          // p1 score
          println("p1 score");
          p1Score++;
          ball.reset();
          
          if (p1Score == winScore) {
            println("p1 wins");
          }
        }
        
        pauseBtn.draw();
    }
    
    
    
  }
  
  void mousePressed() {
    if (!started && startBtn.mouseOver()) {
      started = true;
    }
  }
  
  void gameOver() {
    
  }
}

class PongBall {
  int x, y, d = 50, xSpeed, ySpeed;
  int minSpeed = 5, maxSpeed = 15;
  
  void draw() {
    fill(255); noStroke();
    circle(x, y, d);
  }
  
  void move() {
    x += xSpeed;
    y += ySpeed;
  }
  
  void reset() {
    x = width / 2;
    //y = random(2) < 1 ? pong.courtY + d / 2 : pong.courtY + pong.courtHeight - d / 2;
    y = height / 2; //int(random(pong.courtY, pong.courtY + pong.courtHeight));
    
    xSpeed = int(random(minSpeed, maxSpeed));
    if (random(2) < 1) xSpeed = -xSpeed;
    
    ySpeed = int(random(minSpeed, maxSpeed));
    if (random(2) < 1) ySpeed = -ySpeed;
  }
  
  boolean hitUDWall() {
    if (y - d / 2 < pong.courtY || y + d / 2 > pong.courtY + pong.courtHeight) {
      return true;
    }
    
    return false;
  }
  
  boolean hitPlayer() {
    if (
    
        // hits P1 (LEFT)
        (x - d / 2 <= pong.p1.x + pong.p1.w && 
         y - d / 2 >= pong.p1.y - pong.p1.h / 2 && 
         y + d / 2 <= pong.p1.y + pong.p1.h / 2)
         
         ||
         
        // hits P2 (RIGHT)
        (x + d / 2 >= pong.p2.x - pong.p2.w &&
         y - d / 2 >= pong.p2.y - pong.p2.h / 2 && 
         y + d / 2 <= pong.p2.y + pong.p2.h / 2)
         
       ) {  return true; }
     
     return false;
     
  }
  
  boolean hitLWall() {
    if (!hitPlayer() && x - d / 2 < pong.courtX) { // left wall
      println("hit left wall");
      return true;
    } 
    
    return false;
  }
  
  boolean hitRWall() {
    if (!hitPlayer() && x + d / 2 > pong.courtX + pong.courtWidth) {
      println("hit right wall");
      return true;
    }
    return false;
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
       rect(x + w / 2, y, w, h);
       break;
     case 2:
       rect(x - w / 2, y, w, h);
       break;
    }
  }
  
  void setPos(int y) {
    //this.x = x;
    switch(playerNum) {
      case 1:
        this.x = 0 + pong.courtX;
        break;
      case 2:
        this.x = width - pong.courtX;
        break;
    }
    
    setY(y);
    //this.y = constrain(y, h / 2, pong.courtHeight - h / 2);
    //setAbsPos();
  }
  
  void setY(int y) {
    this.y = constrain(y, pong.courtY + h / 2, pong.courtY + pong.courtHeight - h / 2);
    //setAbsPos();
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
