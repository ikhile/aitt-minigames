class FlappyBird extends Page {
  Rectangle face;
  Rectangle face2;
  Rectangle[] faces;
  
  int score = 0;
  int highScore;
  boolean gameOver = false;
  boolean paused = false;
  boolean newHighScore = false;
  boolean twoPlayer = false;
  
  float scrollSpeed;
  float obstacleGap;  
  float obstacleMinGap = 150;
  float obstacleMaxGap = 300;
  boolean removeObstacle = false;
  
  RectTextBtn playAgain = new RectTextBtn("Play Again", width / 2 + 60, height / 2 + 70, 100, 50);;
  RectTextBtn homeBtn = new RectTextBtn("Home", width / 2 - 60, height / 2 + 70, 100, 50);
  RectTextBtn pause = new RectTextBtn("Pause", width - 120, 35, 100, 50);

  FlappyBirdPlayer player = new FlappyBirdPlayer();
  ArrayList<FlappyBirdObstacle> obstacles = new ArrayList<FlappyBirdObstacle>();
  
  void launch() {
    reset();
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
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
      homeBtn.draw();
      

    } else {
      cam.read();
      opencv.loadImage((PImage)cam);  
      drawWebcamMirrored();
      faces = opencv.detect();
      
      if (faces.length > 0) {
        for (int i = 0; i < faces.length; i++) {
          strokeWeight(i == 0 ? 3 : 1);
          stroke(i == 0 ? 255 : 0, 0, 0); 
          noFill(); rectMode(CORNER);
          drawRectMirrored(faces[i]);
        }
        
        face = faces[0];
        player.setYPos(face.y + face.height / 2); // centre Y of face
      }
      
      //if (twoPlayer) {
      //  strokeWeight(5);
      //  line(width / 2, 0, width / 2, height);
        
      //  for (FlappyBirdObstacle obstacle: obstacles) {
      //    obstacle.move(scrollSpeed);
      //  }
      //} else {
      
      //}
      
      //line(obstacles.get(obstacles.size() - 1).x + obstacles.get(obstacles.size() - 1).w, 0, obstacles.get(obstacles.size() - 1).x + obstacles.get(obstacles.size() - 1).w, height);
      //line(obstacles.get(obstacles.size() - 1).x + obstacles.get(obstacles.size() - 1).w, 0, obstacles.get(obstacles.size() - 1).x + obstacles.get(obstacles.size() - 1).w, height);
      
      if (width - (obstacles.get(obstacles.size() - 1).x + obstacles.get(obstacles.size() - 1).w) >= obstacleGap) {
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
      stroke(255); strokeWeight(1);
      dottedLine(width / 2, 10, width / 2, height - 10, 4, 30);
      //pushMatrix();
      //scale(-1, 1);
      //  line(face.x, face.y + face.height / 2, face.x + face.width , face.y + face.height / 2);
      //        dottedLine(face.x, face.y, player.x, face.y + face.height / 2, 5, 10);
      //popMatrix();
      player.draw();
      
      if (faces.length == 0) {
        textSize(24); fill(255); rectMode(CENTER); textAlign(CENTER, CENTER);
        text("Please move your face into the frame\n(or check your lighting)", width / 2, height / 2);
        // could eventually implement a lil (no face detected for 3 seconds :. pause)
      }
    }
  }
  
  void mousePressed() {
    if (gameOver) {
      if (playAgain.mouseOver()) reset();
      else if (homeBtn.mouseOver()) currentPage = home;
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
    obstacleGap = random(obstacleMinGap, obstacleMaxGap);
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
    newEntry.setString("date", date);
    newEntry.setInt("score", score);
    
    leaderboard.append(newEntry);
    
    data.getJSONObject("flappy-bird").setJSONArray("leaderboard", leaderboard);
    saveJSONObject(data, dataPath);
    
  }
}

int fbPlayerHeight = 50;

class FlappyBirdPlayer {
  PImage img;
  int y = width / 2;
  int x = width / 2;
  int w = fbPlayerHeight;
  int h = fbPlayerHeight;
  int minX;
  int maxX;
  
  FlappyBirdPlayer() {
    img = loadImage("placeholder.png");
    setMinMaxX();
  }
  
  void setYPos(int y) {
    this.y = y;
  }
  
  void setPos(int x, int y) {
    this.x = x;
    this.y = y;
    setMinMaxX();
  }
  
  void setMinMaxX() {
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
int minObsWidth = 150;
int maxObsWidth = 250;

class FlappyBirdObstacle {
  int x = width;
  float w;
  float gapUpper;
  float gapLower;
  boolean passed = false;
  
  FlappyBirdObstacle() {
    w = random(minObsWidth, maxObsWidth);
    gapUpper = random(minGapStartY, height - minGapStartY - fbPlayerHeight * minGapMultiplier);    
    //gapLower = random(gapUpper + fbPlayerHeight * minGapMultiplier, gapUpper + fbPlayerHeight * maxGapMultiplier);
    gapLower = random(gapUpper + fbPlayerHeight * minGapMultiplier, height - minGapStartY);
  }
  
  void setXPos(float x) {
    this.x = int(x);
  }
  
  void move(float distance) {
    x -= distance;
  }
    
  void draw() {
    fill(0, 255, 0); noStroke(); rectMode(CORNER);
    println(x);
    rect(x, 0, w, gapUpper);
    rect(x, gapLower, w, height);
  }
  
  boolean hasHitPlayer(FlappyBirdPlayer player) {
    //stroke(255, 0, 0); line(player.minX, 0, player.minX, height);
    //stroke(0, 255, 0); line(player.maxX, 0, player.maxX, height);
    //stroke(0, 0, 255); line(x + w, 0, x + w, height);
    //stroke(255, 255, 0); line(x, 0, x, height);

    if (( player.minX <= x + w && player.maxX >= x ) && 
        ( player.y - player.h / 2 <= gapUpper || player.y + player.h / 2 >= gapLower )) {
      return true;
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
