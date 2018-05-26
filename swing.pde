final int UNIT_SPACING = 50;
final float GRAVITY = -9.8;
final int FPS = 60;
Hero hero;
Camera cam;
boolean[] keys = new boolean[255];

void setup(){
  fullScreen();
  frameRate(FPS);
  hero = new Hero(width/2, 0, UNIT_SPACING);
  cam = new Camera();
}

void draw(){
  background(155, 100, 75);
  pushMatrix();
  translate(cam.getX(),cam.getY());
  drawGrid(UNIT_SPACING);
  hero.drawHero();
  hero.update();
  popMatrix();
  
  checkInput();
  cam.update();
}

void keyPressed(){
  if(key < 255){
    keys[key] = true;
  }
}
void keyReleased(){
  if(key < 255){
    keys[key] = false;
  }
}

void mousePressed(){
  //check if mouse in tree
  hero.fireVine(mouseX, mouseY);
}

void mouseReleased(){
  hero.releaseVine();
}


void checkInput(){
  if(keys['A'] || keys['a']){
    cam.moveLeft();
  }
  if(keys['D'] || keys['d']){
    cam.moveRight();
  }
  if(keys['W'] || keys['w']){
    cam.moveUp();
  }
  if(keys['S'] || keys['s']){
    cam.moveDown();
  }
}

void drawGrid(int space){
  stroke(0,0,0);
  int limit = 3000;
  for(int i = -limit; i < limit; i+=space){
    line(-limit, i, limit, i);
    line(i, -limit, i, limit);
  }
}
