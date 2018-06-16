import processing.sound.*;
SoundFile mowerSound;
float amplitude = 1;

final int UNIT_SPACING = 50;
final float GRAVITY = -9.8/(UNIT_SPACING/2);
final int FPS = 24;
final int GAME_START = 0;
final int GAME_STAGE_1 = 1;
final int GAME_STAGE_2 = 2;
final int GAME_STAGE_3 = 3;
final int GAME_OVER = 4;
final int FENCE_START = 9600;

Hero hero;
Camera cam;
Clock clock;
Bubble title;
Bubble body;
Bubble dialog;
int gameState = GAME_START;
boolean[] keys = new boolean[255];
Dandelion[] weeds;
Grass[] lawn;
Fence[] fence = new Fence[7];
Insect[] bugs = new Insect[15];
Spider[] brood = new Spider[21];
Mower mower;
float grassPatchSize;
float weedPatchSize;
float grassHeight;
float fenceWidth;
float fenceSpacing;
float shift;
String[] stageTwoText = {"Oh no, come back, my babies! The Grass Eater is gone now, there is nothing to be afraid of. Can anyone help me up here? ^", "The Grass Eater scared my precious little ones into a frenzy, and now they won't come back to my web. Can you gather them up and bring them back to me?"};

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
  grassHeight = height/9; //also using for fence width
  fenceWidth = height/8;
  fenceSpacing = width/5;
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
  fence[0] = new Fence(FENCE_START, -height/4, width*2, fenceWidth/2);
  fence[1] = new Fence(FENCE_START, 3*height/4, width*2, fenceWidth/2);
  for(int i = 2; i < fence.length; i++){
    fence[i] = new Fence(FENCE_START+((i-1)*fenceSpacing), height);
  }
  brood[0] = new Spider(FENCE_START+ fenceWidth, -height/4, true, FENCE_START+ fenceWidth-fenceWidth/2, -height/4 - fenceWidth/2, FENCE_START+ fenceWidth + fenceWidth/2, -height/4 + fenceWidth/2 );
  for(int i = 2; i < fence.length; i++){
    float[] temp = fence[i].getCoordinates();
    println(temp);
    brood[(i-2)*4+1] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3]);
    brood[(i-2)*4+2] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3]);
    brood[(i-2)*4+3] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3]);
    brood[(i-2)*4+4] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3]);
  }
}

void draw(){
  background(0,200,200);
  if(gameState == GAME_START){
    body.display();
    title.display();
  }
  
  ///////////////////////////         STAGE 1        ////////////////////////
  else if(gameState == GAME_STAGE_1){
    pushMatrix();
    translate(cam.getX(),cam.getY());
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 0; i < weeds.length; i++){
      if(shift+weedPatchSize < FENCE_START){
        weeds[i].drawDandelion(shift);
        weeds[i].drawDandelion(shift+weedPatchSize);
      }
      else{
        weeds[i].drawDandelion(shift);
      }
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
    for(int i = 0; i < fence.length; i++){
      fence[i].drawFence();
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
    
    cam.moveRight();
  }
  
  ////////////////////////      STAGE 2       ////////////////////////////////
  else if(gameState == GAME_STAGE_2){
    pushMatrix();
    translate(cam.getX(),cam.getY());
    for(int i = 0; i < fence.length; i++){
      fence[i].drawFence();
    }
    shift = floor(-cam.getX()/grassPatchSize)*grassPatchSize;
    for(int i = 0; i < lawn.length; i++){
      lawn[i].drawGrass(shift);
      lawn[i].drawGrass(shift+grassPatchSize);
      lawn[i].drawGrass(shift+2*grassPatchSize);
      lawn[i].drawGrass(shift+3*grassPatchSize);
      lawn[i].drawGrass(shift+4*grassPatchSize);
    }
    for(int i = 0; i < brood.length; i++){
      brood[i].drawSpider();
      brood[i].update();
    }
    hero.drawHero();
    hero.update();
    popMatrix();
    dialog.display();
  }
  else if(gameState == GAME_OVER){
   background(0,0,0);
   fill(255,0,0);
   text("Game over! Press 'r' to restart.", width/2, height/2);
  }
  checkInput();
  gameState = checkGameState();
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
  if(gameState == GAME_STAGE_1){
    float shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 0; i < weeds.length; i++){
      if(weeds[i].hitDandelion(mouseX-cam.getX(), mouseY+cam.getY(), shift)){
        hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
      }
    }
  }
  else if(gameState == GAME_STAGE_2){
    for(int i = 0; i < fence.length; i++){
      if(fence[i].hitFence(mouseX - cam.getX(), mouseY+cam.getY())){
        hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
      }
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
    for(int i = 0; i < bugs.length; i++){
      bugs[i].reset();
    }
    gameState = GAME_STAGE_1;
    keys['r'] = false;
    keys['R'] = false;
  }
  if(keys['2']){
    gameState = GAME_STAGE_2;
    clock.startTime();
    cam.setPos(FENCE_START + 1.5*fenceWidth, 0);
    hero.setPos(FENCE_START + 1.5*fenceWidth, 0);
    keys['2'] = false;
  }
}
  
int checkGameState(){
  if(gameState == GAME_START){
    return GAME_START;
  }
  float distance = mower.checkDistance(hero.getPosition());
  amplitude = map(distance, 0, width, 2, 0.5); //neat 
  mowerSound.amp(amplitude);
  if(distance <= 0){
    mowerSound.stop();
    return GAME_OVER;
  }
  if(-cam.getX() >= FENCE_START+fenceWidth){
    hero.speechBubbleSwitch(false);
    dialog = new Bubble(0, height/6, width, height/6, false);
    dialog.setText(stageTwoText[0]);
    dialog.setSize(24);
    return GAME_STAGE_2;
  }
  else{
    return GAME_STAGE_1;
  }
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
