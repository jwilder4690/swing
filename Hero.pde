class Hero{
  PVector startPos;
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  boolean webHeld = false;
  Web currentWeb;
  Web oldWeb;
  final int TERMINAL_VELOCITY = 10;
  float damping = .995;
  
  

Hero(float x, float y, int scale){
  pos = new PVector(x,y);
  startPos = new PVector(pos.x,pos.y);
  vel = new PVector(0,0);
  tall = 2*scale;
  wide = scale/2;
  currentWeb = new Web();
  oldWeb = new Web();
}

PVector getPosition(){
  return pos;
}

PVector getVelocity(){
  return vel;
}

void drawHero(){

  if(webHeld){
    currentWeb.drawWeb();
  }
  oldWeb.drawWeb();
  oldWeb.update();
  fill(0,0,0);
  ellipse(pos.x, pos.y, wide, wide);
}

void update(){
  if(webHeld){
    pos = currentWeb.update(damping);
    currentWeb.shortenWeb(); //constantly retracts web
  }
  else{
    vel.y = constrain(vel.y-GRAVITY, -TERMINAL_VELOCITY, TERMINAL_VELOCITY);
    pos.y += vel.y;
    pos.x += vel.x;
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

}
