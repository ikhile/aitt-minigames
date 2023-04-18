class FlappyBird extends Page {
  Rectangle face;
  Rectangle[] faces;
  
  int score = 0;
  int highScore;
  boolean gameOver = false;
  boolean paused = false;
  boolean newHighScore = false;
  
  float scrollSpeed;
  float obstacleGap = 300;  
  float obstacleMinGap = 250;
  float obstacleMaxGap = 400;
  boolean removeObstacle = false;
  
  RectTextBtn playAgain = new RectTextBtn("Play Again", width / 2 + 60, height / 2 + 70, 100, 50);;
  RectTextBtn home= new RectTextBtn("Home", width / 2 - 60, height / 2 + 70, 100, 50);
  RectTextBtn pause = new RectTextBtn("Pause", width - 120, 35, 100, 50);

  FlappyBirdPlayer player = new FlappyBirdPlayer();
  ArrayList<FlappyBirdObstacle> obstacles = new ArrayList<FlappyBirdObstacle>();
  
  void launch() {
    reset();
  }
  
  void draw() {
    background(200);
    textSize(g.textSize); // src: https://forum.processing.org/two/discussion/12660/is-there-a-way-to-access-the-default-textsize.html
    
    
    if (gameOver) {
      drawWebcamMirrored(); // without calling cam.read() first this displays the last frame before game ended, which I think is kinda fun
      
      // draw the game just don't move it
      for (FlappyBirdObstacle obstacle : obstacles) obstacle.draw();      
      player.draw();
      
      noStroke(); fill(255, 255, 255, 150);
      rectMode(CENTER); rect(width / 2, height / 2, width, height);
      
      stroke(0); strokeWeight(3); fill(0, 0, 0, 50);
      rect(width / 2, height / 2, width - 150, height - 150);
      
      fill(255);
      textAlign(CENTER, CENTER);
      text("GAME OVER", width / 2, height / 2 - 50);
      text("score: " + score, width / 2, height / 2);
      text((newHighScore ? "NEW " : "") + "High score: " + highScore, width / 2, height / 2 + 15);
      
      playAgain.draw();
      home.draw();
      

    } else {
      cam.read();
      opencv.loadImage((PImage)cam);  
      drawWebcamMirrored();
      opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
      faces = opencv.detect();
      
      if (faces.length > 0) {
        for (int i = 0; i < faces.length; i++) {
          stroke(i == 0 ? 255 : 0, 0, 0); noFill(); rectMode(CORNER);
          
          // scale same as mirrored webcam image
          pushMatrix();
          scale(-1, 1);
            // must add negative width to x to mirror
            rect(faces[i].x - width, faces[i].y, faces[i].width, faces[i].height);
          popMatrix();
        }
        
        face = faces[0];
        player.setYPos(face.y + face.height / 2); // centre Y of face
      }
      
      if (width - obstacles.get(obstacles.size() - 1).x >= obstacleGap) {
          obstacles.add(new FlappyBirdObstacle());
          obstacleGap = random(obstacleMinGap, obstacleMaxGap);
      }
      
      for (FlappyBirdObstacle obstacle : obstacles) {
        obstacle.move(scrollSpeed);
        obstacle.draw();
        
        if (obstacle.x + obstacle.w < player.x - player.w / 2 && !obstacle.passed) {
          obstacle.passed = true;
          score++;
          if (score % 5 == 0) scrollSpeed++;
        }
        
        else if (obstacle.hasHitPlayer(player)) {
          gameOver = true;
          updateHighScore();
          updateLeaderboard();
        }
        
        if (obstacle.passed && obstacle.x + obstacle.w < 0) {
          removeObstacle = true; // used a variable so as not to interrupt the iteration of obstacles
        }
      }
      
      if (removeObstacle) {
        obstacles.remove(0);
        removeObstacle = false;
      }
      
      // things to draw last - on top of everything else
      stroke(0);
      line(width / 2, 0, width / 2, height);
      player.draw();
      
      if (faces.length == 0) {
        textSize(24); fill(255); rectMode(CENTER); textAlign(CENTER, CENTER);
        text("Please move your face into the frame", width / 2, height / 2);
        // could eventually implement a lil (no face detected for 3 seconds :. pause)
      }
    }
  }
  
  void mousePressed() {
    if (gameOver) {
      if (playAgain.mouseOver()) reset();
      else if (home.mouseOver()) currentPage = homePage;
    }
  }
  
  void reset() {
    score = 0;
    scrollSpeed = 7;
    removeObstacle = false;
    gameOver = false;
    newHighScore = false;
    highScore = data.getJSONObject("flappy-bird").getInt("high-score");
    
    obstacles.clear();
    obstacles.add(new FlappyBirdObstacle());
    obstacles.get(0).setXPos(obstacles.get(0).x - obstacles.get(0).w);  
  }
  
  void updateHighScore() {
    int current = data.getJSONObject("flappy-bird").getInt("high-score");

    if (score > current) {
      highScore = score;
      newHighScore = true;
      data.getJSONObject("flappy-bird").setInt("high-score", highScore);
    }
    
    saveJSONObject(data, dataPath);    
  }
 
  void updateLeaderboard() {
    
    JSONArray leaderboard = data.getJSONObject("flappy-bird").getJSONArray("leaderboard");
    JSONObject newEntry = new JSONObject();
    String date = year() + "-" + month() + "-" + day();
    println(date);
    newEntry.setString("date", date);
    newEntry.setInt("score", score);
    
    leaderboard.append(newEntry);
    
    data.getJSONObject("flappy-bird").setJSONArray("leaderboard", leaderboard);
    saveJSONObject(data, dataPath);
    
    println(leaderboard);
    println(data);
    
  }
}

int fbPlayerHeight = 50;

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
    setXValues();
  }
  
  void setYPos(int y) {
    this.y = y;
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

int minGapStartY = 100;
float minGapMultiplier = 2.0f;
float maxGapMultiplier = 5.0f;

class FlappyBirdObstacle {
  int x = width;
  float w = 150;
  float gapUpper;
  float gapLower;
  boolean passed = false;
  
  FlappyBirdObstacle() {
    // these values *should* ensure that the gap is at least [minGapMultiplier] times the player height, 
    // but doesn't start or end too close to the edges of the screen
    gapUpper = random(minGapStartY, height - minGapStartY - fbPlayerHeight * minGapMultiplier);
    //gapLower = random(gapUpper + fbPlayerHeight * minGapMultiplier, height - minGapStartY);
    
    // but now the gap can be massive - need to constrain somehow
    gapLower = random(gapUpper + fbPlayerHeight * minGapMultiplier, gapUpper + fbPlayerHeight * maxGapMultiplier);
  }
  
  void setXPos(float x) {
    this.x = int(x);
  }
  
  void move(float distance) {
    x -= distance;
  }
  
  // if centreX ~= width / 2 and player.y < gapUpper or player.y > gapLower then fail
  
  void draw() {
    fill(0, 255, 0); noStroke(); rectMode(CORNER);
    rect(x, 0, w, gapUpper);
    rect(x, gapLower, w, height);
  }
  
  boolean hasHitPlayer(FlappyBirdPlayer player) {
    //if (x >= player.minX && x + w <= player.maxX) {
      if (player.minX >= x && player.maxX <= x + w) {
    //if (x >= player.x - player.w / 2 && x + w <= player.maxX) {
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
  RectTextBtn startBtn = new RectTextBtn("Start", width / 2, height - 70, 150, 50);
  
  void draw() {
    background(200);
    text("instructions", width / 2, height / 2);
    startBtn.draw();
  }
  
  void mousePressed() {
    if (startBtn.mouseOver()) {
      setPage(fb);
    }
  }
}
