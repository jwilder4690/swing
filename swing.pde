final int UNIT_SPACING = 50;
Hero hero;
Camera cam;
boolean[] keys = new boolean[255];

void setup(){
  fullScreen();
  hero = new Hero(width/2, height/2, UNIT_SPACING);
  cam = new Camera();
}

void draw(){
  background(155, 100, 75);
  pushMatrix();
  translate(cam.getX(),-cam.getY());
  drawGrid(UNIT_SPACING);
  hero.drawHero();
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
  cam.changeFocus(new PVector(mouseX,mouseY));
}


void checkInput(){
  if(keys['A']){
    cam.moveLeft();
  }
}

void drawGrid(int space){
  int limit = 3000;
  for(int i = -limit; i < limit; i+=space){
    line(-limit, i, limit, i);
    line(i, -limit, i, limit);
  }
}
