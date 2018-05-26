final int UNIT_SPACING = 50;


void setup(){
  fullScreen();
}

void draw(){
  drawGrid(UNIT_SPACING);
}

void drawGrid(int space){
  int limit = 3000;
  for(int i = -limit; i < limit; i+=space){
    line(-limit, i, limit, i);
    line(i, -limit, i, limit);
  }
}
