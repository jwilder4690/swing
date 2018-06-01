final int UNIT_SPACING = 50;
final float GRAVITY = -9.8/UNIT_SPACING;
final int FPS = 60;
Hero hero;
Camera cam;
boolean[] keys = new boolean[255];
Dandelion[] weeds = new Dandelion[50];
Grass[] lawn;
float grassPatchSize;

void setup(){
  fullScreen();
  //size(1080,720);
  frameRate(FPS);
  hero = new Hero(width/2, 0, UNIT_SPACING);
  cam = new Camera();
  grassPatchSize = width/4.0;
  lawn = new Grass[int(grassPatchSize/Grass.grassWidth)];
  for(int i = 0; i < weeds.length; i++){
    weeds[i] = new Dandelion(i*UNIT_SPACING+random(UNIT_SPACING/2), random(0, height/2), int(random(UNIT_SPACING, UNIT_SPACING*3)));
  }
  println(lawn.length);
  for(int i = 0; i < lawn.length; i++){
    lawn[i] = new Grass(random(90,100), i);
    lawn[i].generateGrass();
  }
}

void draw(){
  background(0,200,200);
  pushMatrix();
  translate(cam.getX(),cam.getY());
  for(int i = 0; i < weeds.length; i++){
    weeds[i].drawDandelion();
  }
  for(int i = 0; i < lawn.length; i++){
    float shift = floor(-cam.getX()/grassPatchSize)*grassPatchSize;
    lawn[i].drawGrass(shift);
    lawn[i].drawGrass(shift+grassPatchSize);
    lawn[i].drawGrass(shift+2*grassPatchSize);
    lawn[i].drawGrass(shift+3*grassPatchSize);
    lawn[i].drawGrass(shift+4*grassPatchSize);
  }
  hero.drawHero();
  hero.update();
  popMatrix();
  
  checkInput();
  if(cam.getLocked()){
    cam.lockOnTo(hero.getPosition().x);
  }
  else if(hero.getPosition().x+cam.getX() > 2*width/3){
    cam.setVelocity(hero.getVelocity().x);
    cam.moveRight();
  }
  else if(hero.getPosition().x+cam.getX() < width/3){
    cam.setVelocity(-hero.getVelocity().x);
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
  for(int i = 0; i < weeds.length; i++){
    if(weeds[i].hitDandelion(mouseX-cam.getX(), mouseY+cam.getY())){
      hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
    }
  }
}

void mouseReleased(){
  hero.releaseWeb();
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
    hero.retractWeb();
  }
  if(keys['R'] || keys['r']){
    hero.reset();
    cam.reset();
  }
  
}

//remove later
void drawGrid(int space){
  stroke(0,0,0);
  int limit = 3000;
  for(int i = -limit; i < limit; i+=space){
    line(-limit, i, limit, i);
    line(i, -limit, i, limit);
  }
}
