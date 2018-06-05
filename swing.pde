import processing.sound.*;
SoundFile mowerSound;
float amplitude;

final int UNIT_SPACING = 50;
final float GRAVITY = -9.8/(UNIT_SPACING/2);
final float GRASS_HEIGHT = 100;
final int FPS = 24;
final int START_SCREEN = 0;
final int GAME_PLAY = 1;
final int GAME_OVER = 2;

Hero hero;
Camera cam;
int gameState = GAME_PLAY;
boolean[] keys = new boolean[255];
Dandelion[] weeds;
Grass[] lawn;
Mower mower;
float grassPatchSize;
float weedPatchSize;
float shift;

void setup(){
  fullScreen();
  //size(1080,720);
  frameRate(FPS);
  createAudio();
  mowerSound.loop();
  hero = new Hero(width/2, 0, UNIT_SPACING);
  cam = new Camera();
  mower = new Mower((-height/2)*0.8, height/2, height);
  grassPatchSize = width/4.0;
  weedPatchSize = width;
  lawn = new Grass[int(grassPatchSize/Grass.GRASS_WIDTH)];
  weeds = new Dandelion[int(weedPatchSize/UNIT_SPACING)];
  for(int i = 0; i < weeds.length; i++){
    weeds[i] = new Dandelion(i*UNIT_SPACING+random(UNIT_SPACING/2), random(0, height/2), int(random(UNIT_SPACING, UNIT_SPACING*3)));
  }
  for(int i = 0; i < lawn.length; i++){
    lawn[i] = new Grass(random(0.9*GRASS_HEIGHT,GRASS_HEIGHT), i);
    lawn[i].generateGrass();
  }
}

void draw(){
  if(gameState == GAME_PLAY){
    background(0,200,200);
    pushMatrix();
    translate(cam.getX(),cam.getY());
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 0; i < weeds.length; i++){
      weeds[i].drawDandelion(shift);
      weeds[i].drawDandelion(shift+weedPatchSize);
    }
    shift = floor(-cam.getX()/grassPatchSize)*grassPatchSize;
    for(int i = 0; i < lawn.length; i++){
      lawn[i].drawGrass(shift);
      lawn[i].drawGrass(shift+grassPatchSize);
      lawn[i].drawGrass(shift+2*grassPatchSize);
      lawn[i].drawGrass(shift+3*grassPatchSize);
      lawn[i].drawGrass(shift+4*grassPatchSize);
    }
    hero.drawHero();
    hero.update();
    mower.drawMower();
    mower.update(Mower.MOWER_SPEED);
    popMatrix();
    
    checkInput();
    gameState = checkGameState();
    cam.moveRight(Mower.MOWER_SPEED);
  }
  else if(gameState == GAME_OVER){
   background(0,0,0);
   fill(255,0,0);
   text("Game over! Press 'r' to restart.", width/2, height/2);
   checkInput();
  }
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
  float shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
  for(int i = 0; i < weeds.length; i++){
    if(weeds[i].hitDandelion(mouseX-cam.getX(), mouseY+cam.getY(), shift)){
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
    mower.reset();
    gameState = GAME_PLAY;
    keys['r'] = false;
    keys['R'] = false;
  }
}
  
int checkGameState(){
  float distance = mower.checkDistance(hero.getPosition());
  amplitude = map(distance, 0, width, 2, 0.5); //neat 
  mowerSound.amp(amplitude);
    if(distance <= 0){
      mowerSound.stop();
      return GAME_OVER;
    }
    return GAME_PLAY;
}

void createAudio(){
  mowerSound = new SoundFile(this, "mower.wav");
  mowerSound.amp(amplitude);
}
