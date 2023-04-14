class Button {
  float x;
  float y;
  float w;
  float h;
  float r;
  color fillColour = color(255);
  color strokeColour = color(0);
  color textColour = color(0);
  int strokeWeight = 1;
  float fontSize = g.textSize; // https://forum.processing.org/two/discussion/12660/is-there-a-way-to-access-the-default-textsize.html
  
  Boolean mouseOver() {
    return ( mouseX >= x - w / 2 && mouseX <= x + w / 2 && mouseY >= y - h / 2 && mouseY <= y + h / 2 );
  }
  
  void setFill(color colour) { fillColour = colour; }
  void setStroke(color colour) { strokeColour = colour; }
  void setStrokeWeight(int weight) { strokeWeight = weight; }
  void setTextColour(color colour) { textColour = colour; }
  void setFontSize(float size) { fontSize = size; }
  
  void setColours(color fill, color stroke) {
    fillColour = fill;
    strokeColour = stroke;
  }
  
  void setColours(color fill, color stroke, color text) {
    textColour = text;
    setColours(fill, stroke);
  }
}

class RectTextButton extends Button {
  String text;
 
  RectTextButton(String text, float x, float y, float w, float h, float r) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = r;
    this.text = text;
  }
  
  RectTextButton(String text, float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = 0;
    this.text = text;
  }
  
  void draw() {
    rectMode(CENTER);
    strokeWeight(strokeWeight);
    stroke(strokeColour);
    fill(fillColour);
    rect(x, y, w, h, r);
    
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    fill(textColour);
    text(text, x, y);
  }
}

class CircleTextButton extends Button {
  float d;
  String text;
 
  CircleTextButton(String text, float x, float y, float d) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.w = d;
    this.h = d;
    this.text = text;
  }
  
  void draw() {
    stroke(strokeColour);
    strokeWeight(strokeWeight);
    fill(fillColour);    
    circle(x, y, d);
    
    fill(textColour);
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    text(text, x, y);
  }
}

class ImageButton extends Button {
  PImage image;
  
  ImageButton(String imagePath, float x, float y, float w, float h) {
    this.image = loadImage(imagePath);
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void draw() {
    imageMode(CENTER);
    image(image, x, y, w, h);
  }
}