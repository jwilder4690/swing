final int UNIT_SPACING = 50;
final float GRAVITY = -9.8/UNIT_SPACING;
final int FPS = 60;
Hero hero;
Camera cam;
boolean[] keys = new boolean[255];
Tree[] forest = new Tree[50];

void setup(){
  fullScreen();
  //size(1080,720);
  frameRate(FPS);
  hero = new Hero(width/2, 0, UNIT_SPACING);
  cam = new Camera();
  for(int i = 0; i < forest.length; i++){
    forest[i] = new Tree(i*UNIT_SPACING+random(UNIT_SPACING/2), random(0, height/2), int(random(UNIT_SPACING, UNIT_SPACING*3)));
  }
}

void draw(){
  background(0);
  pushMatrix();
  translate(cam.getX(),cam.getY());
  //drawGrid(UNIT_SPACING);
  for(int i = 0; i < forest.length; i++){
    forest[i].drawTree();
  }
  hero.drawHero();
  hero.update();
  popMatrix();
  
  checkInput();
  if(hero.getPosition().x+cam.getX() > 2*width/3){
    cam.moveRight();
  }
  if(hero.getPosition().x+cam.getX() < width/3){
    cam.moveLeft();
  }
  //cam.update();
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
  for(int i = 0; i < forest.length; i++){
    if(forest[i].hitTree(mouseX-cam.getX(), mouseY+cam.getY())){
      hero.fireVine(mouseX-cam.getX(), mouseY+cam.getY());
    }
  }
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
  if(keys[' ']){
    hero.retractVine();
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
