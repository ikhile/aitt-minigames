class FlappyBird2Player extends Page {
  Rectangle p1Face;
  Rectangle p2Face;
  Rectangle[] faces;
  
  int p1Score = 0, p2Score = 0;
  int highScore;
  boolean p1Hit = false;
  boolean p2Hit = false;
  boolean gameOver = false;
  boolean paused = false;
  boolean newHighScore = false;
  int winner;
  
  float scrollSpeed;
  float obstacleGap;  
  float obstacleMinGap = 150;
  float obstacleMaxGap = 300;
  boolean removeObstacle = false;
  
  RectTextBtn playAgain = new RectTextBtn("Play Again", width / 2 + 60, height / 2 + 200, 100, 50);;
  RectTextBtn homeBtn = new RectTextBtn("Home", width / 2 - 60, height / 2 + 200, 100, 50);
  RectTextBtn pause = new RectTextBtn("Pause", width - 120, 35, 200, 50);

  FlappyBirdPlayer player1 = new FlappyBirdPlayer();
  FlappyBirdPlayer player2 = new FlappyBirdPlayer();
  ArrayList<FB2Obstacle> obstacles1 = new ArrayList<FB2Obstacle>();
  ArrayList<FB2Obstacle> obstacles2 = new ArrayList<FB2Obstacle>();
  
  void launch() {
    reset();
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    player1.setPos(width / 4, height / 2);
    player2.setPos(width * 3/4, height / 2);
  }
  
  void draw() {
    background(200);
    textSize(g.textSize);
    
    if (gameOver) {
      drawWebcamMirrored();
      
      for (FB2Obstacle obstacle : obstacles1) obstacle.draw();  
      for (FB2Obstacle obstacle : obstacles2) obstacle.draw();
      player1.draw();
      player2.draw();
      
      noStroke(); fill(255, 255, 255, 150);
      rectMode(CENTER); rect(width / 2, height / 2, width, height);
      
      stroke(0); strokeWeight(3); fill(0, 0, 0, 50);
      rect(width / 2, height / 2, width - 150, height - 150);
      
      fill(255); textSize(36);
      textAlign(CENTER, CENTER);
      text(
        "GAME OVER\nPlayer 1 scored: " + p1Score +
        "\nPlayer 2 scored: " + p2Score + 
        "\n" + 
        (winner == -1 ? "Draw" : ("Player " + winner + "wins!")) + 
        "\n" +
        (newHighScore ? "NEW " : "") + 
        "High score: " + highScore
      , width / 2, height / 2);
      
            
      playAgain.draw();
      homeBtn.draw();

    } else {
      cam.read();
      opencv.loadImage((PImage)cam);  
      drawWebcamMirrored();
      faces = opencv.detect();
      
      rectMode(CORNER); noStroke();
      fill(255, 0, 0, 50); rect(0, 0, width / 2, height);
      fill(0, 0, 255, 50); rect(width / 2, 0, width / 2, height);
      
      p1Face = null;
      p2Face = null;
      strokeWeight(3); noFill();
      
      for (int i = 0; i < faces.length; i++) {
          if (p1Face == null && faces[i].x + faces[i].width / 2 > width / 2) {
            p1Face = faces[i];
            stroke(255, 0, 0); drawRectMirrored(p1Face); 
            if (!p1Hit) player1.setYPos(p1Face.y + p1Face.height / 2);
            
          } else if (p2Face == null && faces[i].x + faces[i].width / 2 < width / 2) {
            p2Face = faces[i];
            stroke(0, 0, 255); drawRectMirrored(p2Face); 
            if (!p2Hit) player2.setYPos(p2Face.y + p2Face.height / 2);
          }
          
          else { stroke(0); strokeWeight(1); drawRectMirrored(faces[i]); }        
      }
            
      if (!p1Hit && width / 2 - (obstacles1.get(obstacles1.size() - 1).x + obstacles1.get(obstacles1.size() - 1).w) >= obstacleGap) {
        addObstacle();
        
      } else if (!p2Hit && width - (obstacles2.get(obstacles2.size() - 1).x + obstacles2.get(obstacles2.size() - 1).w) >= obstacleGap) {
        addObstacle();
      }
            
      for (FB2Obstacle ob1 : obstacles1) {        
        
        if (!p1Hit) {
          ob1.move(scrollSpeed);
          
          if (ob1.x + ob1.w < player1.x - player1.w / 2 && !ob1.passed) {
            ob1.passed = true;
            p1Score++;
            
            if (p1Score % 5 == 0) scrollSpeed++;
          }
          
          else if (ob1.hasHitPlayer(player1)) {
            p1Hit = true;
            updateHighScore();
            updateLeaderboard();
          }
        }
        
        ob1.draw();
      }
      
      for (FB2Obstacle ob2 : obstacles2) {
        if (!p2Hit) {
          ob2.move(scrollSpeed);
          
          if (ob2.x + ob2.w < player2.x - player2.w / 2 && !ob2.passed) {
            ob2.passed = true;
            p2Score++;
            
            if (p2Score % 5 == 0) scrollSpeed++;
          }
          
          else if (ob2.hasHitPlayer(player2)) {
            p2Hit = true;
            updateHighScore();
            updateLeaderboard();
          }
        }
        
        ob2.draw();
      }
      
      if (p1Hit && p2Hit) {
        gameOver = true;
        if (p1Score > p2Score) winner = 1;
        else if (p2Score > p1Score) winner = 2;
        else if (p1Score == p2Score) winner = -1;
      }

      // things to draw last - on top of everything else
      stroke(255); strokeWeight(1);
      fill(255, 0, 0); dottedLine(width / 4, 10, width / 4, height - 10, 4, 30);
      fill(0, 0, 255); dottedLine(width * 3/4, 10, width * 3/4, height - 10, 4, 30);
      player1.draw();
      player2.draw();
      strokeWeight(5); stroke(255, 0, 0);
      line(width / 2, 0, width / 2, height);
      fill(255); textSize(70);  textAlign(CENTER);
      text(p1Score, width / 4, height * .1);
      text(p2Score, width * .75, height * .1);
      
      textSize(24); fill(255); rectMode(CENTER); textAlign(CENTER, CENTER);
      
      if (p1Face == null) text("No face detected\nPlease move your face into the frame\n(or check your lighting)", width / 4, height / 2);
      if (p2Face == null) text("No face detected\nPlease move your face into the frame\n(or check your lighting)", width * .75, height / 2);
    }
  }
  
  void mousePressed() {
    if (gameOver) {
      if (playAgain.mouseOver()) reset();
      else if (homeBtn.mouseOver()) currentPage = home;
    }
  }
  
  void reset() {
    p1Score = 0;
    p2Score = 0;
    scrollSpeed = 7;
    removeObstacle = false;
    gameOver = false;
    newHighScore = false;
    highScore = data.getJSONObject("flappy-bird").getInt("high-score");
    
    obstacles1.clear();
    addObstacle();
  }
  
  void addObstacle() {
    if (!p1Hit) {
      obstacles1.add(new FB2Obstacle(1));
      
      obstacles2.add(new FB2Obstacle(1));
      FB2Obstacle ob2 = obstacles2.get(obstacles2.size() - 1);
      ob2.makeObstacle2(obstacles1.get(obstacles1.size() - 1));
      
    } else {
      obstacles2.add(new FB2Obstacle(2));
    }
    
    obstacleGap = random(obstacleMinGap, obstacleMaxGap);
      
  }
  
  void updateHighScore() {
    int current = data.getJSONObject("flappy-bird").getInt("high-score");
    int highest = max(p1Score, p2Score);

    if (highest > current) {
      highScore = highest;
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
    newEntry.setInt("score", p1Score);
    
    JSONObject newEntry2 = new JSONObject();
    newEntry2.setString("date", date);
    newEntry2.setInt("score", p2Score);
    
    leaderboard.append(newEntry);
    
    data.getJSONObject("flappy-bird").setJSONArray("leaderboard", leaderboard);
    saveJSONObject(data, dataPath);
    
  }
}


class FB2Obstacle extends FlappyBirdObstacle {
  int playerSide;
  
  FB2Obstacle(int playerSide) {
    super();
    this.playerSide = playerSide;
    this.x = playerSide == 1 ? width / 2 : width;
  }
  
  void makeObstacle2(FB2Obstacle obstacle1) {
    this.playerSide = 2;
    this.x = width;
    this.w = obstacle1.w;
    this.gapUpper = obstacle1.gapUpper;
    this.gapLower = obstacle1.gapLower;
  }
  
  void draw() {
    noStroke(); rectMode(CORNERS);
    
    switch(playerSide) {
      case 1: 
        fill(255, 0, 0);
        rect(x, 0, constrain(x + w, 0, width / 2), gapUpper);
        rect(x, gapLower, constrain(x + w, 0, width / 2), height);
        break;
      case 2:
        fill(0, 0, 255);
        rect(constrain(x, width / 2, width), 0, constrain(x + w, width / 2, width), gapUpper);
        rect(constrain(x, width / 2, width), gapLower, constrain(x + w, width / 2, width), height);
        break;
    }
  }

}
