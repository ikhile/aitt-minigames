class FlappyBird2Player extends Page {
  Rectangle p1Face;
  Rectangle p2Face;
  Rectangle[] faces;
  
  int score = 0, p1Score = 0, p2Score = 0;
  int highScore;
  boolean p1Hit = false;
  boolean p2Hit = false;
  boolean gameOver = false;
  boolean paused = false;
  boolean newHighScore = false;
  
  float scrollSpeed;
  float obstacleGap;  
  float obstacleMinGap = 150;
  float obstacleMaxGap = 300;
  boolean removeObstacle = false;
  
  RectTextBtn playAgain = new RectTextBtn("Play Again", width / 2 + 60, height / 2 + 70, 100, 50);;
  RectTextBtn homeBtn = new RectTextBtn("Home", width / 2 - 60, height / 2 + 70, 100, 50);
  RectTextBtn pause = new RectTextBtn("Pause", width - 120, 35, 100, 50);

  FlappyBirdPlayer player1 = new FlappyBirdPlayer();
  FlappyBirdPlayer player2 = new FlappyBirdPlayer();
  ArrayList<FB2Obstacle> obstacles1 = new ArrayList<FB2Obstacle>();
  ArrayList<FB2Obstacle> obstacles2 = new ArrayList<FB2Obstacle>();
  //ArrayList<FlappyBirdObstacle> obstacles2 = new ArrayList<FlappyBirdObstacle>();
  
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
      
      // draw the game just don't move it
      for (FB2Obstacle obstacle : obstacles1) obstacle.draw();      
      player1.draw();
      player2.draw();
      
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
      println(obstacles1.size(), obstacles2.size());
      cam.read();
      opencv.loadImage((PImage)cam);  
      drawWebcamMirrored();
      faces = opencv.detect();
      
      rectMode(CORNER); noStroke();
      fill(255, 0, 0, 50); rect(0, 0, width / 2, height);
      fill(0, 0, 255, 50); rect(width / 2, 0, width / 2, height);
      
      p1Face = null;
      p2Face = null;
      strokeWeight(1); noFill();
      
      for (int i = 0; i < faces.length; i++) {
          if (p1Face == null && faces[i].x + faces[i].width / 2 > width / 2) {
            p1Face = faces[i];
            stroke(255, 0, 0); drawRectMirrored(p1Face); 
            player1.setYPos(p1Face.y + p1Face.height / 2);
            
          } else if (p2Face == null && faces[i].x + faces[i].width / 2 < width / 2) {
            p2Face = faces[i];
            stroke(0, 0, 255); drawRectMirrored(p2Face); 
            player2.setYPos(p2Face.y + p2Face.height / 2);
          }
          
          else {stroke(0); drawRectMirrored(faces[i]);}        
      }
      
      line(obstacles1.get(obstacles1.size() - 1).x + obstacles1.get(obstacles1.size() - 1).w, 0, obstacles1.get(obstacles1.size() - 1).x + obstacles1.get(obstacles1.size() - 1).w, height);
      
      if (!p1Hit && width / 2 - (obstacles1.get(obstacles1.size() - 1).x + obstacles1.get(obstacles1.size() - 1).w) >= obstacleGap) {
        addObstacle();
      } else if (!p2Hit && width - (obstacles2.get(obstacles2.size() - 1).x + obstacles2.get(obstacles2.size() - 1).w) >= obstacleGap) {
        addObstacle();
      }
      
      println(width - (obstacles2.get(obstacles2.size() - 1).x + obstacles2.get(obstacles2.size() - 1).w) >= obstacleGap);
      
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
            println("P1 hit");
            updateHighScore(); // actually could leave - if the next player gets higher will auto update
            updateLeaderboard();
          }
        }
        
        //if (ob1.passed && ob1.x + ob1.w < 0) {
        //    removeObstacle = true;
        //}
        
        ob1.draw();
      }
      
      //for (int i = 0; i < obstacles2.size(); i++) { 
      for (FB2Obstacle ob2 : obstacles2) {
        //FB2Obstacle ob2 = obstacles2.get(i);
        
        //ob1.move(scrollSpeed);    ob2.move(scrollSpeed);
        //ob1.draw();               ob2.draw();
        
        
        
        
        if (!p2Hit) {
          ob2.move(scrollSpeed);
          
          if (ob2.x + ob2.w < player2.x - player2.w / 2 && !ob2.passed) {
            ob2.passed = true;
            p2Score++;
            
            if (p2Score % 5 == 0) scrollSpeed++;
          }
          
          else if (ob2.hasHitPlayer(player2)) {
            //p2Hit = true;
            println("P2 hit");
            updateHighScore(); // actually could leave - if the next player gets higher will auto update
            updateLeaderboard();
          }
        }
        
        ob2.draw();
        
        //if (ob1.passed && ob1.x + ob1.w < 0) {
        //    removeObstacle = true;
        //}
      }
      
      //for (FB2Obstacle obstacle : obstacles1) {
      //  obstacle.move(scrollSpeed);
      //  obstacle.draw();
        
      //  if (obstacle.x + obstacle.w < player1.x - player1.w / 2 && !obstacle.passed) {
      //    obstacle.passed = true;
      //    score++;
      //    if (score % 5 == 0) scrollSpeed++;
      //  }
        
      //  else if (obstacle.hasHitPlayer(player1)) {
      //    gameOver = true;
      //    updateHighScore();
      //    updateLeaderboard();
      //  }
        
      //  if (obstacle.passed && obstacle.x + obstacle.w < 0) {
      //    removeObstacle = true; // used a variable so as not to interrupt the iteration of obstacles
      //  }
      //}
      
      //if (removeObstacle) {
      //  obstacles1.remove(0);
      //  removeObstacle = false;
      //}
      
      //for (FB2Obstacle obstacle: obstacles2) {
      //  obstacle.move(scrollSpeed);
      //  obstacle.draw();
      //}
      
      // things to draw last - on top of everything else
      stroke(255); strokeWeight(1);
      dottedLine(width / 4, 10, width / 4, height - 10, 4, 30);
      dottedLine(width * 3/4, 10, width * 3/4, height - 10, 4, 30);
      player1.draw();
      player2.draw();
      strokeWeight(5); stroke(255, 0, 0);
      line(width / 2, 0, width / 2, height);
      
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
    
    obstacles1.clear();
    addObstacle();
    
    //println(obstacles2);
  }
  
  void addObstacle() {
    if (!p1Hit) {
      println("adding 2 new");
      obstacles1.add(new FB2Obstacle(1));
      
      obstacles2.add(new FB2Obstacle(1));
      FB2Obstacle ob2 = obstacles2.get(obstacles2.size() - 1);
      ob2.makeObstacle2(obstacles1.get(obstacles1.size() - 1));
      
    } else {
      println("adding 1 new");
      obstacles2.add(new FB2Obstacle(2));
    }
    
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
    fill(0, 255, 0); noStroke(); rectMode(CORNERS);
    
    switch(playerSide) {
      case 1: 
        rect(x, 0, constrain(x + w, 0, width / 2), gapUpper);
        rect(x, gapLower, constrain(x + w, 0, width / 2), height);
        break;
      case 2:
        rect(constrain(x, width / 2, width), 0, constrain(x + w, width / 2, width), gapUpper);
        rect(constrain(x, width / 2, width), gapLower, constrain(x + w, width / 2, width), height);
        break;
    }
  }

}
