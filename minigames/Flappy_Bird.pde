int fbPlayerHeight = 50;

class FlappyBird extends Page {
  Rectangle[] faces;
  Rectangle face;
  
  float scrollSpeed = 5;
  float newObstacleMillis = 3000;
  float lastObstacleMillis = 0;
  int score = 0;
  boolean removeObstacle = false;
  
  float obstacleGap = 300;
  
  FlappyBirdPlayer player;
  FlappyBirdObstacle test;
  
  ArrayList<FlappyBirdObstacle> obstacles = new ArrayList<FlappyBirdObstacle>();
  
  FlappyBird() {
    player = new FlappyBirdPlayer();
    test = new FlappyBirdObstacle();
    
    obstacles.add(new FlappyBirdObstacle());
    obstacles.get(0).setXPos(obstacles.get(0).x - obstacles.get(0).w); 
  }
  
  void draw() {
    background(200);
    textSize(g.textSize); // src: https://forum.processing.org/two/discussion/12660/is-there-a-way-to-access-the-default-textsize.html
    //text("flappy bird game", width / 2, height / 2);
    
    cam.read();
    opencv.loadImage((PImage)cam);  
    drawWebcamMirrored();
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = opencv.detect();
    
    println(faces.length);
    if (faces.length > 0) {
      for (int i = 0; i < faces.length; i++) {
        stroke(i == 0 ? 255 : 0, 0, 0); noFill(); rectMode(CORNER);
        
        // scale same as mirrored webcam image
        pushMatrix();
        scale(-1, 1);
          // subtract width from x to mirror
          rect(faces[i].x - width, faces[i].y, faces[i].width, faces[i].height);
        popMatrix();
      }
      
      face = faces[0];
      player.setYPos(face.y + face.height / 2); // centre Y of face
    }
    
    //test.draw();
    
    
    if (faces.length == 0) {
      textSize(24); fill(255);
      text("Please move your face into the frame", width / 2, height / 2);
      
      // could eventually implement a lil (no face detected for 3 seconds :. pause)
    }
    
    //test.move(scrollSpeed);
    
    //if (millis() - lastObstacleMillis >= newObstacleMillis) {
    //    obstacles.add(new FlappyBirdObstacle());
    //    lastObstacleMillis = millis();
    //}
    
    if (width - obstacles.get(obstacles.size() - 1).x >= obstacleGap) {
        obstacles.add(new FlappyBirdObstacle());
    }
    
    for (FlappyBirdObstacle obstacle : obstacles) {
      obstacle.move(scrollSpeed);
      obstacle.draw();
      
      if (obstacle.x + obstacle.w < player.x) {
        removeObstacle = true;
        score++;
        println("obstacle passed");
        println(score);
      }
      
      else if (obstacle.hasHitPlayer(player)) {
        //console.log(
      }
    }
    
    player.draw();
    
    if (removeObstacle) {
      obstacles.remove(0);
      removeObstacle = false;
    }
    
  }
}

class FlappyBirdPlayer {
  int y = width / 2;
  int x = width / 2;
  int minX;
  int maxX;
  int w = fbPlayerHeight;
  int h = fbPlayerHeight;
  PImage img;
  
  FlappyBirdPlayer() {
    img = loadImage("placeholder.png");
  }
  
  void setYPos(int y) {
    this.y = y;
    setXValues();
  }
  
  void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void setXValues() {
    minX = this.x - w / 2;
    maxX = this.x + w / 2;
  }
  
  void draw() {
    imageMode(CENTER);
    image(img, x, y, w, h);
  }
  
  
}

class FlappyBirdObstacle {
  int x = width;
  float w = 150;
  float gapUpper;
  float gapLower;
  //float gapHeight;
  
  FlappyBirdObstacle() {
    gapUpper = random(height * .15, height * .6);
    //gapHeight = random(fbPlayerHeight * 1.5, fbPlayerHeight * 4);
    gapLower = gapUpper + random(fbPlayerHeight * 1.5, fbPlayerHeight * 4);
  }
  
  void setXPos(float x) {
    this.x = int(x);
  }
  
  void move(float distance) {
    x -= distance;
  }
  
  // if centreX ~= width / 2 and player.y < gapUpper or player.y > gapLower then fail
  
  void draw() {
    //rectMode(CENTER)
    rect(x, 0, w, gapUpper);
    rect(x, gapLower, w, height);
  }
  
  boolean hasHitPlayer(FlappyBirdPlayer player) {
    if (x >= player.minX && x <= player.maxX) {
      println("player in obstacle");
      if (player.y - player.h / 2 <= gapUpper || player.y + player.h / 2 >= gapLower) {
        println("hit");
        return true;
      }
    }
    return false;
  }
}


class FlappyBirdIntro extends Page {
  RectTextButton startBtn = new RectTextButton("Start", width / 2, height - 70, 150, 50);
  
  void draw() {
    background(200);
    text("instructions", width / 2, height / 2);
    startBtn.draw();
  }
  
  void mousePressed() {
    if (startBtn.mouseOver()) {
      currentPage = fb;
    }
  }
}
