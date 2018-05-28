class Hero{
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  boolean vineHeld = false;
  Vine currentVine;
  Vine oldVine;
  final int TERMINAL_VELOCITY = 10;
  float damping = .995;
  
  

Hero(float x, float y, int scale){
  pos = new PVector(x,y);
  vel = new PVector(0,0);
  tall = 2*scale;
  wide = scale;
  currentVine = new Vine();
  oldVine = new Vine();
}

PVector getPosition(){
  return pos;
}

void drawHero(){
  fill(0,255,0);
  rectMode(CORNER);
  rect(pos.x - wide, pos.y, wide, tall);
  if(vineHeld){
    currentVine.drawVine();
  }
  oldVine.drawVine();
  oldVine.update();
}

void update(){
  if(vineHeld){
    pos = currentVine.update(damping);
    currentVine.shortenVine(); //constantly retracts vine
  }
  else{
    vel.y = constrain(vel.y-GRAVITY, -TERMINAL_VELOCITY, TERMINAL_VELOCITY);
    pos.y += vel.y;
    pos.x += vel.x;
  }
}

void fireVine(float mX, float mY){
  vineHeld = true;
  currentVine = new Vine(pos.x, pos.y, mX, mY); 
  currentVine.setAngle();
}

void releaseVine(){
  if(vineHeld){
    vineHeld = false;
    oldVine = currentVine;
    oldVine.setAngle();
    vel = currentVine.getTrajectory();
    vel.mult(currentVine.getLinearVelocity());
  }
}

void retractVine(){
  currentVine.shortenVine();
}

}
