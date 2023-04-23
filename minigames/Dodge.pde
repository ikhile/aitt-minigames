class Dodge extends Page {
  int zones = 5;
  float[] zoneCentres = new float[zones];
  DodgePlayer player;
  int endZoneH = 150;
  float flowSensitivity = 0.2f;
  boolean flowPause = false;
  int flowPauseMillis = 500;
  int millisAtPause;
  int millisNew;
  int millisLastNew;
  int obsGap;
  int fallSpeed = 25;
  int score;
  int numHit, maxHits = 3;
  ArrayList<DodgeObstacle> obstacles = new ArrayList<DodgeObstacle>();
  boolean removeObstacle;
  boolean gameOver;
  boolean started;
  
  RectTextBtn homeBtn;
  RectTextBtn startBtn;
  RectTextBtn quitBtn;

  Dodge() {
    for (int i = 0; i < zones; i++) {
      zoneCentres[i] = (width / zones + 1) * i + (width / ((zones + 1) * 2));
    }
    
    // put everything perfectly in the middle due to rounding errors
    if (zones % 2 != 0) {
      float offset = width / 2 - zoneCentres[zones / 2];
      for (int i = 0 ; i < zones; i++ ) { zoneCentres[i] += offset; }
    }
    
    homeBtn = new RectTextBtn("Home", 60, 35, 100, 50, 10);
    homeBtn.setColours(color(0, 0, 0, 170), color(255), color(255));
    homeBtn.setStrokeWeight(3);
    
    quitBtn = new RectTextBtn("Quit", 60, 35, 100, 50, 10);
    quitBtn.setColours(color(0, 0, 0, 170), color(255), color(255));
    quitBtn.setStrokeWeight(3);
    
    startBtn = new RectTextBtn("Start", width / 2, height * .8, 150, 70, 20);
    startBtn.setColours(color(255, 0, 255, 70), color(255), color(255));
    startBtn.setStrokeWeight(3);
  }

  void launch() {
    player = new DodgePlayer();
    obstacles.add(new DodgeObstacle());
    millisNew = 3000;
    millisLastNew = millis();
    obsGap = 200;
    score = 0;
    numHit = 0;
    removeObstacle = false;
    gameOver = false;
    started = false;
  }

  void draw() {
    
    textAlign(CENTER, CENTER);
    
    if (gameOver) {
      drawWebcamMirrored();

      // draw a dotted line at centre of each zone
      fill(255, 255, 255, 100); noStroke();
      for (int i = 0; i < zones; i++) {
        dottedLine(zoneCentres[i], 0, zoneCentres[i], height, 3, 40);
      }
      
      fill(255); rectMode(CENTER);
      text("Game over\nYou scored " + score, width / 2, height / 2);
      homeBtn.draw();
      startBtn.draw();
      
    } else if (!started) {
      background(0);
      
      rectMode(CENTER);
      textSize(28);
      text(
        "Catch the green balls - but avoid the red!\n\nMove the player left and right " + 
        "by moving your head or body within frame of the camera - each time you move, the player moves one space in that direction" +
        "\n\n\nTip - you can also move your device from side to side to move the player!"
      , width / 2, height / 2, width * .6, height / 2);
      
      startBtn.draw();
      homeBtn.draw();
      
    } else {
  
      cam.read();
      opencv.loadImage((PImage)cam);
      drawWebcamMirrored();
  
      // draw a dotted line at centre of each zone
      fill(255, 255, 255, 100); noStroke();
      for (int i = 0; i < zones; i++) {
        dottedLine(zoneCentres[i], 0, zoneCentres[i], height, 3, 40);
      }
      
      for (DodgeObstacle obstacle : obstacles) {
        obstacle.draw();
        obstacle.move();
        
        if (obstacle.reachedEndZone()) {
          removeObstacle = true;
          if (obstacle.zoneIndex == player.zoneIndex) {
            if (obstacle.isCollectible) score++;
            else numHit++;
          }
          
          if (score % 5 == 0) {
            fallSpeed += 10;
          }
        }
      }
      
      if (removeObstacle) obstacles.remove(0); removeObstacle = false;
      if (numHit > maxHits) gameOver = true;
      
      // changed below to more of a "gap between" type deal
      //if (millis() - millisLastNew >= millisNew) {
      //  obstacles.add(new DodgeObstacle());
      //  millisLastNew = millis();
      //}
            
      if (obstacles.get(obstacles.size() - 1).y > obsGap) {
          obstacles.add(new DodgeObstacle());
      }
  
      player.draw();
      stroke(0, 0, 0, 150); strokeWeight(3);
      line(0, height - endZoneH, width, height - endZoneH);
      
      textAlign(RIGHT); textSize(32);
      text("Score: " + score +  "\nStrikes: " + numHit + "/" + maxHits, width - 30, 50);
  
      if (flowPause && millis() - millisAtPause >= flowPauseMillis) {
        flowPause = false;
      }
  
      if (!flowPause) {
        opencv.calculateOpticalFlow();
        
        if (opencv.getAverageFlow().x > flowSensitivity) {
          player.move('L');
          flowPause = true;
          millisAtPause = millis();
          
        } else if (opencv.getAverageFlow().x < -flowSensitivity) {
          player.move('R');
          flowPause = true;
          millisAtPause = millis();
        }
      } 
      
      quitBtn.draw();
    }
    
  }

  void mousePressed() {
    if (!started && startBtn.mouseOver()) {
      started = true;
      
    } else if (gameOver && startBtn.mouseOver()) {
      launch();
      started = true;
    }
    
    else if (homeBtn.mouseOver() || quitBtn.mouseOver()) {
      setPage(home);
    }
  }
              

}

class DodgeObstacle {
  int y;
  int zoneIndex;
  int w, h;
  boolean isCollectible;

  DodgeObstacle() {
    this.w = int(random(50, 150));
    this.h = int(random(50, 150));
    this.zoneIndex = int(random(dodge.zones));
    this.y = -h;
    this.isCollectible = random(5) < 4 ? true : false; // so not 50/50
  }

  void draw() {
    fill(isCollectible ? color(0, 255, 0) : color(255, 0, 0));
    ellipse(dodge.zoneCentres[zoneIndex], y, w, h);
  }
  
  void move() {
    y += dodge.fallSpeed;
  }
  
  boolean reachedEndZone() {
    return y + h / 2 >= height - dodge.endZoneH;
  }
}

class DodgePlayer {
  float x, y;
  int w = 100;
  int h = 100;
  int zoneIndex;

  DodgePlayer() {
    zoneIndex = dodge.zoneCentres.length / 2;
    setXPos();
    this.y = height - dodge.endZoneH / 2;
  }

  void setXPos() {
    this.x = dodge.zoneCentres[zoneIndex];
  }

  void draw() {
    fill(255);
    ellipse(x, y, w, h);
  }

  void move(char dir) {
    switch (dir) {
    case 'L':
      this.zoneIndex--;
      break;
    case 'R':
      this.zoneIndex++;
      break;
    }

    zoneIndex = constrain(zoneIndex, 0, dodge.zones - 1);
    setXPos();
  }
}
