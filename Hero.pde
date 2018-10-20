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
  float angle = 0;
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
  if(gameState == Game.STAGE_2){
    return 2*wide;
  }
  else{
    return wide;
  }
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
  strokeWeight(4);
  stroke(0,0,0);
  pushMatrix();
  translate(pos.x, pos.y);
  rotate(angle);
  if(webHeld){
    line(0,0, wide, 0.2*wide);
    line(wide, 0.2*wide, 0.7*wide, wide);
    line(0,0, 0.9*wide, 0.5*wide);
    line(0.9*wide, 0.5*wide, wide, 1.3*wide);
    line(0,0, 0.6*wide, 0.8*wide);
    line(0.6*wide, 0.8*wide, 0.5*wide, 1.7*wide);
    line(0,0, 0.3*wide, wide);
    line(0.3*wide, wide, 0.2*wide, 2*wide);
    pushMatrix();
    scale(-1,1);
    line(0,0, wide, 0.2*wide);
    line(wide, 0.2*wide, 0.7*wide, wide);
    line(0,0, 0.9*wide, 0.5*wide);
    line(0.9*wide, 0.5*wide, wide, 1.3*wide);
    line(0,0, 0.6*wide, 0.8*wide);
    line(0.6*wide, 0.8*wide, 0.5*wide, 1.7*wide);
    line(0,0, 0.3*wide, wide);
    line(0.3*wide, wide, 0.2*wide, 1.9*wide);
    popMatrix();
  }
  else{
    line(0,0, 0.5*wide, -wide);
    line(0.5*wide, -wide, 0.8*wide, 0);
    line(0,0, 0.8*wide,-0.8*wide);
    line(0.8*wide,-0.8*wide, wide, .2*wide);
    line(0,0, wide, -0.5*wide);
    line(wide, -0.5*wide, wide, 0.5*wide);
    line(0,0, 0.8*wide, 0.3*wide);
    line(0.8*wide, 0.3*wide, 0.9*wide, 0.8*wide);
    pushMatrix();
    scale(-1,1);
    line(0,0, 0.5*wide, -wide);
    line(0.5*wide, -wide, 0.8*wide, 0);
    line(0,0, 0.8*wide,-0.8*wide);
    line(0.8*wide,-0.8*wide, wide, .2*wide);
    line(0,0, wide, -0.5*wide);
    line(wide, -0.5*wide, wide, 0.5*wide);
    line(0,0, 0.8*wide, 0.3*wide);
    line(0.8*wide, 0.3*wide, 0.9*wide, 0.8*wide);
    popMatrix();
  }
  
  noStroke();
  ellipse(0,0, wide, wide);
  
  popMatrix();
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
      angle = TWO_PI - currentWeb.getAngle();
    }
    else{
      pos.y = groundLevel+wide/2;
      angle = 0;
    }
  }
  else if(webHeld){
    pos = currentWeb.update(damping);
    currentWeb.shortenWeb(); //constantly retracts web
    angle = TWO_PI - currentWeb.getAngle();
  }
  else{
    vel.y = constrain(vel.y-GRAVITY, -TERMINAL_VELOCITY, TERMINAL_VELOCITY);
    pos.y += vel.y;
    pos.x += vel.x;
    angle = 0;
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

void clearOldWeb(){
  oldWeb = new Web();
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
