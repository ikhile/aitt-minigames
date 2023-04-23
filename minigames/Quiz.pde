class Quiz4 extends Page { // four option quiz
  int qIndex = 0;
  Rectangle faces[];
  int sectionStrokeWeight = 6;
  int sw = 6;
  int sectionAlpha = 80;
  int numberCorrect = 1;
  int numberWrong = 0;
  int qTimer = 10000;
  boolean showAnswer = true;
  RectTextBtn nextQ = new RectTextBtn("NEXT", width / 2, height * .75 - 100, 100, 50);

  Question4Choices questions[] = {
    new Question4Choices("q", "a", "w1", "w2", "w3")
  };

  void launch(){
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  };
  
  void draw() {
    background(255);
    
    if (showAnswer) {     
      if (opencv.getInput() != null) drawWebcamMirrored(); 
      // using sw var to make it look like they have inner borders with no border overlap
      rectMode(CORNER); textAlign(CENTER); 

      drawSections();
      drawAnswers();
      
      
      String text = "Correct answer:\n" + questions[qIndex].answers[questions[qIndex].correctIndex] + "\n\n";
      if (numberWrong == 0) {
        if (numberCorrect == 1) text += "You got it right!";
        else text += "You all got it right!";
      } else {
        text += numberCorrect + " of you were right and " + numberWrong + " of you were wrong";
      }
      
      rectMode(CENTER); fill(0, 0, 0, 100); noStroke();
      rect(width / 2, height / 2, width / 2, height / 2);
      
      fill(255); textAlign(CENTER, CENTER); 
      text(text, width / 2, height / 2 - 50, width / 2, height / 2);
      
      nextQ.draw();
      
    } else {
    
    // OPEN CV
    cam.read();
    opencv.loadImage((PImage)cam); 
    faces = opencv.detect();
    drawWebcamMirrored();  
    
    numberCorrect = 0; numberWrong = 0;
    
    for (Rectangle face: faces) { // draw face in colour based on its position and count number of faces in right vs wrong answer sections
      noFill(); 
      
      int centreX = face.x + face.width / 2;
      int centreY = face.y + face.height / 2;
      if (centreX >= width / 2 && centreY <= height / 2) { // have to flip comparison to width as mirrored
        stroke(255, 0, 0);
        
        if (questions[qIndex].correctIndex == 0) numberCorrect++;
        else numberWrong++;
        
      } else if (centreX <= width / 2 && centreY <= height / 2) {
        stroke(255, 255, 0);
        
        if (questions[qIndex].correctIndex == 1) numberCorrect++;
        else numberWrong++;
        
      } else if (centreX >= width / 2 && centreY >= height / 2) {
        stroke(0, 255, 0);
        
        if (questions[qIndex].correctIndex == 2) numberCorrect++;
        else numberWrong++;
        
      } else if (centreX <= width / 2 && centreY >= height / 2) {
        stroke(0, 0, 255);
        
        if (questions[qIndex].correctIndex == 3) numberCorrect++;
        else numberWrong++;
      }
      
      drawRectMirrored(face);
    }    
    
    drawSections();
    
    // question text
    rectMode(CENTER); 
    fill(255); textSize(48); textAlign(CENTER, BASELINE); 
    text(questions[qIndex].question, width / 2, height / 2);
    
    drawAnswers();
    
    }

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
    textSize(32); fill(255);
    text(questions[qIndex].answers[0], width / 4, height / 4);
    text(questions[qIndex].answers[1], width * .75, height / 4);
    text(questions[qIndex].answers[2], width / 4, height * .75);
    text(questions[qIndex].answers[3], width * .75, height * .75);
  }
} // maybe make a page for each question type with like 10 Qs of that type... yeah

// when drawing faces, colour the face to match the answer zone it is in so it's clear which answer they're going for
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
