class Hero{
  PVector startPos;
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  boolean webHeld = false;
  Web currentWeb;
  Web oldWeb;
  int leashLength = 50;
  final int TERMINAL_VELOCITY = 20;
  float damping = .99;
  float grassDrag = .75;
  
  //Dialog/////
  Bubble speechBubble;
  String[] quotes = {"Run!", "Get out of the way!", "Flee for your lives, the Grass Eater has awakened!"};
  int duration = 124;
  int interval = 15000;
  final int INTERVAL_STEP  = 15000;
  
  

Hero(float x, float y, int scale){
  pos = new PVector(x,y);
  startPos = new PVector(pos.x,pos.y);
  vel = new PVector(0,0);
  tall = 2*scale;
  wide = scale/2;
  currentWeb = new Web();
  oldWeb = new Web();
  speechBubble = new Bubble(pos.x, pos.y, wide, (2*tall)/3, false);
  speechBubble.setText(quotes[0]);
  speechBubble.setSize(24);
  speechBubble.adjustToText();
}

PVector getPosition(){
  return pos;
}

PVector getVelocity(){
  return vel;
}

int getSize(){
  return wide;
}

void setPos(float x, float y){
  pos.set(x,y);
}

void drawHero(){
  if(webHeld){
    currentWeb.drawWeb();
  }
  oldWeb.drawWeb();
  oldWeb.update();
  fill(0,0,0);
  ellipse(pos.x, pos.y, wide, wide);
  speechBubble.display();
  speechBubble.update(pos);
}

void update(){
  /////////////////////////////////Position////////////////////////////////////////////
  if(pos.y > height-grassHeight){
    if(webHeld){
    pos = currentWeb.update(grassDrag);
    currentWeb.shortenWeb(); //constantly retracts web
    currentWeb.shortenWeb();
    }
    else{
      pos.y =  height-0.9*grassHeight;
    }
  }
  else if(webHeld){
    pos = currentWeb.update(damping);
    currentWeb.shortenWeb(); //constantly retracts web
  }
  else{
    vel.y = constrain(vel.y-GRAVITY, -TERMINAL_VELOCITY, TERMINAL_VELOCITY);
    pos.y += vel.y;
    pos.x += vel.x;
  }
  //////////////////////////////Dialog///////////////////////////////////////////////////////
  if(gameState == GAME_STAGE_1){
    if(clock.getElapsedTime() / interval > 0 && interval < 100000){
      interval += INTERVAL_STEP;
      duration = 124;
      speechBubble.setVisibility(true);
      speechBubble.setText(quotes[int(random(quotes.length))]);
      speechBubble.adjustToText();
      
    }
    if(duration > 0){
      duration--;
      if(duration == 0){
        speechBubble.setVisibility(false);
      }
    }
  }
}


void fireWeb(float mX, float mY){
  webHeld = true;
  currentWeb = new Web(pos.x, pos.y, mX, mY); 
  currentWeb.setAngle();
}

void releaseWeb(){
  if(webHeld){
    webHeld = false;
    oldWeb = currentWeb;
    oldWeb.setAngle();
    vel = currentWeb.getTrajectory();
    vel.mult(currentWeb.getLinearVelocity());
  }
}

void retractWeb(){
  currentWeb.shortenWeb();
}

void reset(){
  webHeld = false;
  pos = new PVector(startPos.x, startPos.y);
  vel = new PVector(0,0);
}

void speechBubbleSwitch(boolean turn){
  speechBubble.setVisibility(turn);
}

}
