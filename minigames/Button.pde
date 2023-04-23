class Button {
  float x;
  float y;
  float w;
  float h;
  float r;
  color fillColour = color(255);
  color strokeColour = color(0);
  color textColour = color(0);
  boolean noStroke = false;
  boolean noFill = true;
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
  void setNoStroke() { noStroke = true; }
  void setNoFill() { noFill = true; }
  
  void setColours(color fill, color stroke) {
    fillColour = fill;
    strokeColour = stroke;
  }
  
  void setColours(color fill, color stroke, color text) {
    textColour = text;
    setColours(fill, stroke);
  }
}

class RectTextBtn extends Button {
  String text;
 
  RectTextBtn(String text, float x, float y, float w, float h, float r) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = r;
    this.text = text;
  }
  
  RectTextBtn(String text, float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.r = 0;
    this.text = text;
  }
  
  void draw() {
    rectMode(CENTER);
    if (noStroke) { noStroke(); }
    else { stroke(strokeColour); strokeWeight(strokeWeight); }
    
    if (noFill) { noFill(); }
    else { fill(fillColour); }
    
    rect(x, y, w, h, r);
    
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    fill(textColour);
    text(text, x, y);
  }
}

class CircleTextBtn extends Button {
  float d;
  String text;
 
  CircleTextBtn(String text, float x, float y, float d) {
    this.x = x;
    this.y = y;
    this.d = d;
    this.w = d;
    this.h = d;
    this.text = text;
  }
  
  void draw() {
    if (noStroke) { noStroke(); }
    else { stroke(strokeColour); strokeWeight(strokeWeight); }
    
    if (noFill) { noFill(); }
    else { fill(fillColour); }
    
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
