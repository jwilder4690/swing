class Bubble{
  final int LINE_MAX = 25;
  final int PADDING = 70;
  PVector pos;
  float wide;
  float tall;
  float radius = 15;
  float baseHeight;
  int offset = 25;
  color background = color(150,255,255);
  color textColor = color(0,0,0);
  color border = color(0,150,255);
  int size = 48;
  String message = "zZzZz... Hm? What's that noise? Oh crap, it's the Roaring Grass Eater! I've gotta get out of here.";
  boolean textOnly = false;
  boolean visible = true;
  PFont font;
  
  Bubble(){
    this(0,height,width, height, false);
  }
  Bubble(boolean textOnly){
    this(0,height,width, height, textOnly);
  }
  Bubble(float x, float y, float bw, float bh, boolean textOnly){  //x, y are bottom left
    pos = new PVector(x,y);
    wide = bw;
    tall = bh;
    baseHeight = bh;
    font = createFont("BodoniMTCondensed-Bold-48.vlw", 48);
    textFont(font);
    textAlign(CENTER,CENTER);
    this.textOnly = textOnly;
  }
  
  void setText(String msg){
    message = msg;
  }
  
  void setSize(int newSize){
    size = newSize;
  }
  
  void adjustToText(){
    if(message.length() > LINE_MAX){
      wide = PADDING+(size*message.length()/6);
      tall = 2*baseHeight;
    }
    else{
      wide = PADDING+(size*message.length()/3);
      tall = baseHeight;
    }
  }
  
  void update(PVector input){
    pos = new PVector(input.x + offset, input.y - offset);
  }
  
  void setVisibility(boolean flip){
    visible = flip;
  }
  
  void display(){
    if(!visible){
      return;
    }
    textSize(size);
    if(textOnly){
      fill(textColor);
      text(message, pos.x, pos.y-tall, wide, tall);
    }
    else{
      stroke(border);
      strokeWeight(2);
      fill(background);
      rect(pos.x, pos.y-tall, wide, tall, radius, radius, radius, radius);
      fill(textColor);
      text(message, pos.x, pos.y-tall, wide, tall);
    }
  }
}
