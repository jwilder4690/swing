import processing.sound.*;
SoundFile mowerSound, grunt, meow, grumble, yowl, wee, woo, yay, ok;
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
final int POND_START = 20000;
final int ERROR = -45;

Hero hero;
Camera cam;
Clock clock;
Bubble title;
Bubble body;
Bubble dialog;
int gameState = GAME_START;
int progress = GAME_START;
boolean waiting = true;
boolean[] keys = new boolean[255];
Dandelion[] weeds;
Grass[] lawn;
Fence[] fence = new Fence[17];
Insect[] bugs = new Insect[15];
Spider[] brood = new Spider[21];
Mower mower;
Cat cat;
Pond pond;
float grassPatchSize;
float weedPatchSize;
float grassHeight;
float fenceWidth;
float fenceSpacing;
float shift;
String[] stageTwoText = {"Oh no, come back, my babies! The Grass Eater is gone now, there is nothing to be afraid of. Can anyone help me up here?", "The Grass Eater scared my precious little ones into a frenzy, and now they won't come back to my web. Can you gather them up and bring them back to me?", "All my children have returned to me, thank you so much Spider Bro!"};

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
  pond = new Pond(height/10);
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
  float[] temp = fence[2].getCoordinates();
  float[]temp2 = fence[3].getCoordinates();
  brood[0] = new Spider(temp[2], -height/4, true, temp[2], -height/4, temp2[0], (-height/4) + (temp2[0]-temp[2]),0);
  for(int i = 2; i < 7; i++){ //7 are the first fence posts where stage 2 takes place. 
    temp = fence[i].getCoordinates();
    brood[(i-2)*4+1] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3],0);
    brood[(i-2)*4+2] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3],1);
    brood[(i-2)*4+3] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3],2);
    brood[(i-2)*4+4] = new Spider(random(temp[0], temp[2]), random(temp[1], 0), false, temp[0], temp[1], temp[2], temp[3],3);
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
      if(shift+weedPatchSize < FENCE_START-1.5*fenceWidth){
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
    pond.drawPond();
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
    brood[0].drawHomeWeb();
    int count = 0;
    for(int i = 0; i < brood.length; i++){
      brood[i].drawSpider();
      brood[i].update();
      if(brood[i].checkCaught(hero.getPosition(), hero.getSize(), brood[0].getPosition())){
        brood[i].setBounds(brood[0].getBounds());
      }
      if(brood[i].getSafe()){  
        count++;
      }
    }
    
    //if(count == 2){
    if(count == brood.length){
      dialog.setText(stageTwoText[2]);
      if(-cam.getX() >= FENCE_START+(5*fenceWidth)){
        dialog.setVisibility(false);
      }
      else{
        dialog.setVisibility(true);
      }  
      
      if(waiting){
        cat.stopHunting();
        if(cat.getPosition().x < FENCE_START){
          waiting = false;
        }
      }
      else{
        cam.lockOnTo(hero.getPosition().x);
      }
    }

    if(hero.catFollowing){
      cat.drawCat();
      cat.update(hero.getPosition());
    }
    hero.drawHero();
    hero.update();
    popMatrix();
    
    if(cam.getY() >= height/2){
      if(hero.getPosition().y > height/2-height/8){
        cat.swipe();
      }
      else{
        cat.resetCooldown();
      }
    }
    
    ///////////////////////Dialog handling////////////////////////////////
    if(clock.getElapsedTime() > 2000 && !hero.webHeld && clock.getElapsedTime() < 6000){
      hero.fireWeb(FENCE_START + 5*fenceWidth, -height/4);
    }
    if(clock.getElapsedTime() > 3000 && cam.getY() < height/2 && waiting){
      cam.moveUp();
      if(cam.getY() >= height/2){
        dialog.setText(stageTwoText[1]);
        clock.startTime();
      }
    }
    else if(clock.getElapsedTime() > 3000 && cam.getY() >= height/2 && !hero.catFollowing){  //cat enters meow
      dialog.setVisibility(false); 
      hero.toggleCatFollowing();
      yowl.play();
    }
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
  else if(gameState == GAME_STAGE_2 || gameState == GAME_STAGE_1){
    for(int i = 0; i < fence.length; i++){
      if(fence[i].hitFence(mouseX - cam.getX(), mouseY-cam.getY())){
        hero.fireWeb(mouseX-cam.getX(), mouseY-cam.getY());
      }
    }
  }
}

void mouseReleased(){
  hero.releaseWeb();
}


void checkInput(){
  if(keys['A'] || keys['a']){
    hero.moveLeft();
  }
  if(keys['D'] || keys['d']){
    hero.moveRight();
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
    switch(progress){
      case GAME_START: 
      case GAME_STAGE_1:{
        clock.startTime();
        hero.reset();
        cam.reset();
        mower.reset();
        for(int i = 0; i < bugs.length; i++){
          bugs[i].reset();
        }
        gameState = GAME_STAGE_1;
        progress = GAME_STAGE_1;
        break;
      }
    case GAME_STAGE_2: {
      gameState = GAME_STAGE_2;
      progress = GAME_STAGE_2;
      hero.reset();
      clock.startTime();
      hero.speechBubbleSwitch(false);
      dialog = new Bubble(0, height/6, width, height/6, false);
      dialog.setText(stageTwoText[0]);
      dialog.setSize(24);
      cam.setPos(FENCE_START + 1.5*fenceWidth, 0);
      hero.setPos(FENCE_START + 1.5*fenceWidth, 0);
      cat.reset(hero.getPosition(), height/2);
      for(int i = 1; i < brood.length; i++){
        brood[i].reset();
      }
    }
    default:  break;
    }
    keys['r'] = false; 
    keys['R'] = false;
  }
  
  /////////////////////////Testing use only///////////////////////////
  if(keys['2']){
    gameState = GAME_STAGE_2;
    progress = GAME_STAGE_2;
    clock.startTime();
    hero.speechBubbleSwitch(false);
    dialog = new Bubble(0, height/6, width, height/6, false);
    dialog.setText(stageTwoText[0]);
    dialog.setSize(24);
    cam.setPos(FENCE_START + 1.5*fenceWidth, 0);
    hero.setPos(FENCE_START + 1.5*fenceWidth, 0);
    cat = new Cat(hero.getPosition(), height/2);
    keys['2'] = false;
  }
}
  
int checkGameState(){
  if(gameState == GAME_START){
    return GAME_START;
  }
  else if(gameState == GAME_OVER){
    return GAME_OVER;
  }
  else if(gameState == GAME_STAGE_1){
    float distance = mower.checkDistance(hero.getPosition());
    amplitude = map(distance, 0, width, 2, 0.5); //neat 
    mowerSound.amp(amplitude);
    if(distance <= 0){
      mowerSound.stop();
      return GAME_OVER;
    }
  }
  else if(gameState == GAME_STAGE_2){
    if(hero.getHealth() <= 0){
      return GAME_OVER;
    }
  }
  
  ////////////////////Stage Check//////////////////////////////////
  if(-cam.getX() >= POND_START){
    progress = GAME_STAGE_3;
    return GAME_STAGE_3;
  }
  if(-cam.getX() >= FENCE_START + 1.5*fenceWidth){
    if(gameState != GAME_STAGE_2){
      hero.speechBubbleSwitch(false);
      dialog = new Bubble(0, height/6, width, height/6, false);
      dialog.setText(stageTwoText[0]);
      dialog.setSize(24);
      clock.startTime();
      //cam.setPos(FENCE_START + 1.5*fenceWidth, 0);
      //hero.setPos(FENCE_START + 1.5*fenceWidth, 0);
      cat = new Cat(new PVector(FENCE_START - 1.5*fenceWidth,0), height/2);
    }
    progress = GAME_STAGE_2;
    return GAME_STAGE_2;
  }
  else{
    progress = GAME_STAGE_1;
    return GAME_STAGE_1;
  }
}

void createAudio(){
  mowerSound = new SoundFile(this, "mower.wav");
  grunt = new SoundFile(this, "grunt.wav");
  meow = new SoundFile(this, "cat1.wav");
  grumble = new SoundFile(this, "catGrumble.mp3");
  yowl = new SoundFile(this, "catEntrance.mp3");
  wee = new SoundFile(this, "wee.wav");
  woo = new SoundFile(this, "woo.wav");
  yay = new SoundFile(this, "yay.wav");
  ok = new SoundFile(this, "ok.wav");
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
