class Hero{
  PVector pos;
  PVector vel;
  int tall;
  int wide;
  

Hero(float x, float y, int scale){
  pos = new PVector(x,y);
  tall = 2*scale;
  wide = scale;
}

void drawHero(){
  fill(0,255,0);
  rectMode(CORNER);
  rect(pos.x - wide, pos.y, wide, tall);
}

}
