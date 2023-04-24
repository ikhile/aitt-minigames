class Quiz4 extends Page { // four option quiz
  int qIndex = 0;
  Rectangle faces[];
  int sectionStrokeWeight = 6;
  int sw = 6;
  int sectionAlpha = 80;
  int numberCorrect = 1;
  int numberWrong = 0;
  boolean showAnswer = false, started = false;
  RectTextBtn nextQ = new RectTextBtn("NEXT", width / 2, height * .75 - 100, 100, 50);
  RectTextBtn startBtn = new RectTextBtn("Start", width / 2, height / 2 + 150, 100, 50);
  RectTextBtn homeBtn = new RectTextBtn("Home", width / 2 + 80, height / 2 + 150, 100, 50);
  RectTextBtn homeBtn2 = new RectTextBtn("Home", 60, 35, 100, 50);
  
  int timerStart, timerLength = 10000, timerCurrent;
  
  Quiz4() {
    homeBtn2.setColours(color(255, 255, 255, 60), color(255), color(255));
    homeBtn2.setStrokeWeight(3);
  }

  Question4Choices questions[] = {
    new Question4Choices(
      " Construction of which of these famous landmarks was completed first?",
      "Big Ben Clock Tower",
      "Empire State Building",
      "Royal Albert Hall", 
      "Eiffel Tower"
    ),
    
    new Question4Choices(
      "Which of these religious observances lasts for the shortest period of time during the calendar year?",
      "Divali",
      "Ramadan",
      "Lent", 
      "Hanukkah"
    ),
    
    new Question4Choices(
      "In Doctor Who, what was the signature look of the fourth Doctor, as portrayed by Tom Baker?",
      "Wide-brimmed hat and extra long scarf",
      "Bow-tie, braces and tweed jacket",
      "Pinstripe suit and trainers", 
      "Cape, velvet jacket and frilly shirt"
    ),
    
    new Question4Choices(
      "The hammer and sickle is one of the most recognisable symbols of which political ideology?",
      "Communism",
      "Republicanism",
      "Conservatism", 
      "Liberalism"
    ),
    
    new Question4Choices(
      "What does the word loquacious mean?",
      "Chatty",
      "Angry",
      "Beautiful", 
      "Shy"
    ),
    
    new Question4Choices(
      "Which of these brands was chiefly associated with the manufacture of household locks?",
      "Chubb",
      "Phillips",
      "Flymo",
      "Ronseal"
    ),
    
    new Question4Choices(
      "Which Disney character famously leaves a glass slipper behind at a royal ball?",
      "Cinderella",
      "Pocahontas",
      "Sleeping Beauty",
      "Elsa"
    ),
    
    new Question4Choices(
      "Obstetrics is a branch of medicine particularly concerned with what?",
      "Childbirth",
      "Broken bones",
      "Heart conditions",
      "Old age"
    ),
    
    new Question4Choices(
      "In 1718, which pirate died in battle off the coast of what is now North Carolina?",
      "Blackbeard",
      "Calico Jack",
      "Bartholomew Roberts",
      "Captain Kidd"
    ),
    
    new Question4Choices(
      "Which of these cetaceans is classified as a 'toothed whale'?",
      "Sperm whale",
      "Gray whale",
      "Minke whale",
      "Humpback whale"
    ),
    
    new Question4Choices(
      "At the closest point, which island group is only 50 miles south-east of the coast of Florida?",
      "Bahamas",
      "US Virgin Islands",
      "Turks and Caicos Islands",
      "Bermuda"
    )
  };

  void launch() {
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    showAnswer = false;
    started = false;
  };
  
  void draw() {
    background(255);
    
    if (!started) {
      background(125, 212, 175);
      fill(255); textSize(24);
      text("Answer the questions by moving your face to your chosen answer before time runs out!\nPlay alone or with friends", width / 2, height / 2, width / 2, height);
      startBtn.draw();
    }
    
    else if (showAnswer) {     
      if (opencv.getInput() != null) drawWebcamMirrored(); 
      rectMode(CORNER); textAlign(CENTER); textSize(48);

      drawSections();
      drawFaces();
      drawAnswers();
      
      String text = "Correct answer:\n" + questions[qIndex].answers[questions[qIndex].correctIndex] + "\n\n";
      
      if (numberWrong == 0 && numberCorrect == 0) text += "No one answered";
      
      else if (numberWrong == 0) {
        if (numberCorrect == 1) text += "You got it right!";
        else text += "You all got it right!";
        
      } else if (numberCorrect == 0) {
        if (numberWrong == 1) text += "You got it wrong";
        else text += "You were all wrong";
        
      } else {
        text += numberCorrect + " of you " + (numberCorrect == 1 ? "was" : "were") + " right and "
              + numberWrong + " of you " + (numberWrong == 1 ? "was" : "were") + " wrong";
      }
      
      rectMode(CENTER); fill(0, 0, 0, 100); noStroke();
      rect(width / 2, height / 2, width / 2, height / 2);
      
      fill(255); textAlign(CENTER, CENTER); 
      text(text, width / 2, height / 2 - 50, width / 2, height / 2);
      
      if (qIndex < questions.length - 1) nextQ.draw();
      else {
        textSize(24); text("No more questions", width / 2 - 80, height / 2 + 150);
        homeBtn.draw();
      }
      
    } else {
    
      // OPEN CV
      cam.read();
      opencv.loadImage((PImage)cam); 
      faces = opencv.detect();
      drawWebcamMirrored();  
      
      numberCorrect = 0; numberWrong = 0;
      
      drawFaces();
      drawSections();
      
      // question text
      rectMode(CENTER); 
      fill(255); textSize(36); textAlign(CENTER, CENTER); 
      text(questions[qIndex].question, width / 2, height / 2 - 100, width / 2, height);
      
      fill(0, 0, 0, 220); stroke(255); strokeWeight(4);
      circle(width / 2, height / 2 + 60, 70);
      fill(255); textSize(36); textAlign(CENTER, CENTER);
      text(int((timerLength - (millis() - timerStart)) / 1000) + 1, width / 2, height / 2 + 53);
      
      drawAnswers();
            
      if (millis() - timerStart >= timerLength) {
        showAnswer  = true;
      }
    
    }
    
    homeBtn2.draw();

  }
  
  void mousePressed() {
    if (homeBtn2.mouseOver()) {
      setPage(home);
      
    } else if (!started && startBtn.mouseOver()) {
      started = true;
      timerStart = millis();
      
    } else if (showAnswer && nextQ.mouseOver() && qIndex < questions.length - 1) {
      nextQuestion();
        
    } else if (showAnswer && qIndex >= questions.length - 1 && homeBtn.mouseOver()) {
      setPage(home);
    }
  }
  
  void nextQuestion() {
    qIndex++;
    showAnswer = false;
    timerStart = millis();
  }
  
  void drawSections() {
    // using sw var to make it look like they have inner borders with no border overlap
    rectMode(CORNER); strokeWeight(sw); 
    
    stroke(255, 0, 0); fill(255, 0, 0, sectionAlpha);
    rect(sw / 2, sw / 2, width / 2 - sw, height / 2 - sw);
    
    stroke(255, 255, 0); fill(255, 255, 0, sectionAlpha);
    rect(width / 2 + sw / 2, sw / 2, width / 2 - sw, height / 2 - sw);
    
    stroke(0, 255, 0); fill(0, 255, 0, sectionAlpha);
    rect(sw / 2, height / 2 + sw / 2, width / 2 - sw, height / 2 - sw);
    
    stroke(0, 0, 255); fill(0, 0, 255, sectionAlpha);
    rect(width / 2 + sw / 2, height / 2 + sw / 2, width / 2 - sw, height / 2 - sw);
  }
  
  void drawAnswers() {
    textSize(32); fill(255); textAlign(CENTER, CENTER);
    text(questions[qIndex].answers[0], width / 4, height / 4);
    text(questions[qIndex].answers[1], width * .75, height / 4);
    text(questions[qIndex].answers[2], width / 4, height * .75);
    text(questions[qIndex].answers[3], width * .75, height * .75);
  }
  
  void drawFaces() {
    for (Rectangle face: faces) { // draw face in colour based on its position and count number of faces in right vs wrong answer sections
        noFill(); 
        
        int centreX = face.x + face.width / 2;
        int centreY = face.y + face.height / 2;
        if (centreX >= width / 2 && centreY <= height / 2) { // have to flip comparison to width as mirrored
          stroke(255, 0, 0);
          
          if (!showAnswer) {
            if (questions[qIndex].correctIndex == 0) numberCorrect++;
            else numberWrong++;
          }
          
        } else if (centreX <= width / 2 && centreY <= height / 2) {
          stroke(255, 255, 0);
          
          if (!showAnswer) {
            if (questions[qIndex].correctIndex == 1) numberCorrect++;
            else numberWrong++;
          }
          
        } else if (centreX >= width / 2 && centreY >= height / 2) {
          stroke(0, 255, 0);
          
          if (!showAnswer) {
            if (questions[qIndex].correctIndex == 2) numberCorrect++;
            else numberWrong++;
          }
          
        } else if (centreX <= width / 2 && centreY >= height / 2) {
          stroke(0, 0, 255);
          
          if (!showAnswer) {
            if (questions[qIndex].correctIndex == 3) numberCorrect++;
            else numberWrong++;
          }
        }
        
        drawRectMirrored(face);
      }
  }
}

class Question4Choices {
  String question;
  String correctAnswer;
  ArrayList<String> wrongAnswers = new ArrayList<String>();
  String answers[] = new String[4];
  int correctIndex;
  
  Question4Choices(String q, String answer, String wrongA1, String wrongA2, String wrongA3) {
    question = q;
    correctAnswer = answer;
    wrongAnswers.add(wrongA1);
    wrongAnswers.add(wrongA2);
    wrongAnswers.add(wrongA3);
    
    shuffleAnswers();
  }
  
  void shuffleAnswers() {
    correctIndex = int(random(0, 4));
    Collections.shuffle(wrongAnswers);
    
    answers[correctIndex] = correctAnswer;
    for (int i = 0; i < 4; i++) {
      if (i != correctIndex) answers[i] = wrongAnswers.remove(0);
    }
  }  
}

class Question2Choices {
  String question;
  String correctAnswer;
  String wrongAnswer;
  
}

class TrueFalseQuestion extends Question2Choices {
  // use this to keep true and false on the same side consistently while changing correct answer
  String question;
  boolean correctAnswer;
}
