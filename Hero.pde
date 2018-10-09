class Hero{
  PVector startPos;
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  boolean webHeld = false;
  boolean catFollowing = false;
  Web currentWeb;
  Web oldWeb;
  int leashLength = 50;
  float groundLevel;
  final int TERMINAL_VELOCITY = 20;
  final float DRIFT_SPEED = .1;
  float damping = .99;
  float grassDrag = .75;
  int health = 3;
  
  
  //Dialog/////
  Bubble speechBubble;
  String[] quotes = {"Run!", "Get out of the way!", "Flee for your lives, the Grass Eater has awakened!"};
  String outro = "We did it, the Yard is safe again!";
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
  groundLevel = height - grassHeight;
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

int getHealth(){
  return health;
}

void setHealth(int hp){
  health = hp;
}

void toggleCatFollowing(){
  catFollowing = !catFollowing;
}

void setPos(float x, float y){
  pos.set(x,y);
}

void setGroundLevel(float ground){
  groundLevel = ground;
}

void drawHero(){
  if(webHeld){
    currentWeb.drawWeb();
  }
  oldWeb.drawWeb();
  oldWeb.update();
  fill(0,0,0);
  noStroke();
  ellipse(pos.x, pos.y, wide, wide);
  speechBubble.display();
  speechBubble.update(pos);
}

void update(){
  /////////////////////////////////Position////////////////////////////////////////////
  if(pos.y > groundLevel){
    if(webHeld){
      pos = currentWeb.update(grassDrag);
      currentWeb.shortenWeb(); //constantly retracts web
      currentWeb.shortenWeb();
    }
    else{
      pos.y = groundLevel+wide/2;
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
  if(gameState == Game.STAGE_1){
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

void takeDamage(){
  grunt.trigger();
  health--;
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

void moveLeft(){
  if(!webHeld){
    vel.x -= DRIFT_SPEED;
  }
}

void moveRight(){
  if(!webHeld){
    vel.x += DRIFT_SPEED;
  }
}

void reset(){
  health = 3;
  catFollowing = false;
  webHeld = false;
  pos = new PVector(startPos.x, startPos.y);
  vel = new PVector(0,0);
}

void toggleFinalText(){
    speechBubble.setVisibility(true);
    speechBubble.setText(outro);
    speechBubble.adjustToText();
}

void speechBubbleSwitch(boolean turn){
  speechBubble.setVisibility(turn);
}

}
