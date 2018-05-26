class Hero{
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  boolean vineHeld = false;
  Vine currentVine;
  Vine oldVine;
  final int TERMINAL_VELOCITY = 10;
  
  

Hero(float x, float y, int scale){
  pos = new PVector(x,y);
  vel = new PVector(0,0);
  tall = 2*scale;
  wide = scale;
  oldVine = new Vine();
}

void drawHero(){
  fill(0,255,0);
  rectMode(CORNER);
  rect(pos.x - wide, pos.y, wide, tall);
  if(vineHeld){
    currentVine.drawVine();
  }
  oldVine.drawVine();
  oldVine.fall();
}

void update(){
  if(vineHeld){
  //pendulum physics
  }
  else{
    vel.y = constrain(vel.y-GRAVITY/UNIT_SPACING, -TERMINAL_VELOCITY, TERMINAL_VELOCITY);
    pos.y += vel.y;
  }
}

void fireVine(float mX, float mY){
  vineHeld = true;
  currentVine = new Vine(pos.x, pos.y, mX, mY); 
}

void releaseVine(){
  vineHeld = false;
  oldVine = currentVine;
  oldVine.setAngle();
  oldVine.setFalling();
}

}
