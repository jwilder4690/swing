import processing.sound.*;
SoundFile mowerSound;
float amplitude = 1;

final int UNIT_SPACING = 50;
final float GRAVITY = -9.8/(UNIT_SPACING/2);
final int FPS = 24;
final int GAME_START = 0;
final int GAME_PLAY = 1;
final int GAME_OVER = 2;

Hero hero;
Camera cam;
Clock clock;
Bubble title;
Bubble body;
int gameState = GAME_START;
boolean[] keys = new boolean[255];
Dandelion[] weeds;
Grass[] lawn;
Insect[] bugs = new Insect[15];
Mower mower;
float grassPatchSize;
float weedPatchSize;
float grassHeight;
float shift;

void setup(){
  //fullScreen();
  size(1080,720);
  frameRate(FPS);
  createAudio();
  generateStartScreen();
  hero = new Hero(width/2, 0, UNIT_SPACING);
  clock = new Clock();
  cam = new Camera();
  mower = new Mower((-height/2)*0.8, height/2, height);
  grassPatchSize = width/4.0;
  weedPatchSize = width;
  grassHeight = height/9;
  lawn = new Grass[int(grassPatchSize/Grass.GRASS_WIDTH)];
  weeds = new Dandelion[int(weedPatchSize/UNIT_SPACING)];
  for(int i = 0; i < weeds.length; i++){
    weeds[i] = new Dandelion(i*UNIT_SPACING+random(UNIT_SPACING/2), random(0, height/2), int(random(UNIT_SPACING, UNIT_SPACING*3)));
  }
  for(int i = 0; i < lawn.length; i++){
    lawn[i] = new Grass(random(0.9*grassHeight,grassHeight), i);
    lawn[i].generateGrass();
  }
  for(int i = 0; i < bugs.length; i++){
    bugs[i] = new Insect(random(width), height - 0.6*grassHeight, random(grassHeight/8, grassHeight/6), 15);
  }
}

void draw(){
  if(gameState == GAME_START){
    checkInput();
    body.display();
    title.display();
  }
  else if(gameState == GAME_PLAY){
    background(0,200,200);
    pushMatrix();
    translate(cam.getX(),cam.getY());
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 0; i < weeds.length; i++){
      weeds[i].drawDandelion(shift);
      weeds[i].drawDandelion(shift+weedPatchSize);
    }
    for(int i = 0; i < bugs.length; i++){
      bugs[i].drawInsect();
      bugs[i].update();
      if(frameCount % 48 == 0 && i % 2 == 0){
        if(mower.checkDistance(bugs[i].getPosition()) < width/3){
          bugs[i].jump();
        }
      }
      if(frameCount % 24 == 0 && i % 2 != 0){
        if(mower.checkDistance(bugs[i].getPosition()) < width/3){
          bugs[i].jump();
        }
      }
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
    mower.update();
    popMatrix();
    
    checkInput();
    gameState = checkGameState();
    cam.moveRight();
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
    clock.startTime();
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

void generateStartScreen(){
  title = new Bubble(0, height/6, width, height/6, true);
  title.setSize(72);
  title.setText("The Adventures of Spider Bro");
  body = new Bubble();
  body.setText("Help Spider Bro protect his friends and complete his missions as a Gaurdian of the Yard. Do your best to help out those in need! \n\n Controls: \n Click and hold inside the dandelion tops to swing. Press SPACE to retract your web faster. \n\n\n\n When you are ready, press 'R' to begin.");
  body.setSize(24);
}
