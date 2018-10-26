import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioSample grunt, meow, grumble, yowl, wee, woo, yay, ok, frog;
AudioPlayer song, mowerSound, nature;
float amplitude = 1;

final int UNIT_SPACING = 50;
final int TEXT_SIZE = 64;
final float GRAVITY = -9.8/(UNIT_SPACING/2);
final int FPS = 24;
enum Game {START, STAGE_1, STAGE_2, STAGE_3, FINAL, OVER}
final int ERROR = -45;
int FENCE_START;
int POND_START;
int POND_FINAL;
color SKY = color(0,200,200);

PImage background;

Hero hero;
Camera cam;
Clock clock;
Bubble title, body, endLeft, endRight;
Bubble dialog;
Game gameState = Game.START;
Game progress = Game.START;
boolean waiting = true;
boolean roundUp = false;
boolean[] keys = new boolean[255];
Dandelion[] weeds;
Cattail[] waterWeeds;
Grass[] lawn;
Grass[] waterGrass;
Fence[] fence;
Cloud[] sky = new Cloud[20];
Cloud[] skyCredits = new Cloud[3];
Insect[] bugs = new Insect[15];
Spider[] brood = new Spider[21];
LillyPad[] pads = new LillyPad[20];
Butterfly[] butterflies = new Butterfly[10];
Mower mower;
Cat cat;
Frog[] frogs = new Frog[10];
Pond pond;
Rock rock;
float grassPatchSize;
float weedPatchSize;
float grassHeight;
float fenceWidth;
float fenceSpacing;
float padSize;
float shift;
String[] stageTwoText = {"Oh no, come back, my babies! The Grass Eater is gone now, there is nothing to be afraid of. Can anyone help me up here?", "The Grass Eater scared my precious little ones into a frenzy, and now they won't come back to my web. Can you swing into them and send them back to me?", "All my children have returned to me, thank you so much Spider Bro!"};
String[] stageThreeText = {"These two frogs have frightened this group of butterflies! I can protect them by pulling them away from the frogs with my web. Click and hold to pull them, drag and release to fling them.","Ok, now I've got enough web to round them up! Get a leash on each of them."};


void setup(){
  fullScreen(P2D); 
  //size(1080,720, P2D);
  frameRate(FPS);
  background = loadImage("splash.png");
  background.resize(width, height);
  FENCE_START = width*9;
  POND_START = width*12;
  POND_FINAL = width*20;
  grassPatchSize = width/4.0;
  weedPatchSize = width;
  grassHeight = height/9; 
  fenceWidth = height/8;
  padSize = height/8;
  fenceSpacing = width/5;
  dialog = new Bubble(0, height/6, width, height/6, false);
  createAudio();
  generateStartScreen();
  hero = new Hero(width/2, .75*height, UNIT_SPACING);
  clock = new Clock();
  cam = new Camera();
  mower = new Mower((-height/2)*0.8, height/2, height);
  pond = new Pond(grassHeight);
  rock = new Rock(POND_START, height, height/3);
  fence = new Fence[int(5*((POND_START-FENCE_START)/width))+1]; 
  lawn = new Grass[int(grassPatchSize/Grass.GRASS_WIDTH)];
  waterGrass = new Grass[int(grassPatchSize/Grass.GRASS_WIDTH)];
  weeds = new Dandelion[int(weedPatchSize/UNIT_SPACING)];
  waterWeeds = new Cattail[int(weedPatchSize/UNIT_SPACING)+2];
  for(int i = 0; i < weeds.length; i++){
    weeds[i] = new Dandelion(i*UNIT_SPACING+random(UNIT_SPACING/2), random(0, height/2), int(random(UNIT_SPACING, 3*UNIT_SPACING)));
  }
  waterWeeds[0] = new Cattail(UNIT_SPACING/2, height/4, 1.2*UNIT_SPACING);
  waterWeeds[1] = new Cattail(-3*UNIT_SPACING/2, height/4, 1.2*UNIT_SPACING);
  for(int i = 2; i < waterWeeds.length; i++){
    waterWeeds[i] = new Cattail((i-2)*UNIT_SPACING+random(UNIT_SPACING/2), random(0, 3*height/7), random(0.9*UNIT_SPACING, 1.2*UNIT_SPACING));
  }
  for(int i = 0; i < lawn.length; i++){
    lawn[i] = new Grass(random(0.9*grassHeight,grassHeight), i);
    lawn[i].generateGrass();
    waterGrass[i] = new Grass(random(0.75*height,height), i);
    waterGrass[i].generateGrass();
  }
  for(int i = 0; i < bugs.length; i++){
    bugs[i] = new Insect(random(width), height - 0.6*grassHeight, random(grassHeight/8, grassHeight/6), 15);
  }
  fence[0] = new Fence(FENCE_START, -height/4, POND_START- FENCE_START, fenceWidth/2);
  fence[1] = new Fence(FENCE_START, 3*height/4, POND_START- FENCE_START, fenceWidth/2);
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
  pads[0] = new LillyPad(POND_FINAL, height - height/20, padSize, 0);
  for(int i = 1; i < pads.length; i++){
      pads[i] = new LillyPad((POND_START+width+padSize)+random(0,POND_FINAL-POND_START), random(height - height/15, height), padSize, random(0,TWO_PI));
  }
  frogs[0] = new Frog(POND_FINAL - width/2 + waterWeeds[0].getCenter(), height/3, UNIT_SPACING/2, 0);
  frogs[1] = new Frog(POND_FINAL + width/2 + waterWeeds[1].getCenter(), height/3, UNIT_SPACING/2, 0);
  for(int i = 2; i < frogs.length; i++){
      frogs[i] = new Frog(pads[i-1].getPosition().x, pads[i-1].getPosition().y - UNIT_SPACING/2, 2*UNIT_SPACING/5, 1);
  }
  waterWeeds[0].setForeground(frogs[0]);
  waterWeeds[1].setForeground(frogs[1]);
  
  for(int i = 0; i < butterflies.length; i++){
    butterflies[i] = new Butterfly(POND_FINAL, height/3, UNIT_SPACING, 1);
  }
  for(int i = 0; i < sky.length; i++){
    sky[i] = new Cloud(random(POND_FINAL - width/2, POND_FINAL + width/2), -height/4-(i*random(height/5,height/3)), random(height/4,height/3));
  }
  initializeCloudText();

}

void draw(){
  background(SKY);
  ////////////////////////////////////////         Splash Screen        /////////////////////////////////////////
  if(gameState == Game.START){
    drawSplash();
  }
  
  ////////////////////////////////////////         STAGE 1        /////////////////////////////////////////
  else if(gameState == Game.STAGE_1){
    pushMatrix();
    translate(cam.getX(),cam.getY());
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 0; i < weeds.length; i++){
      if(shift+weedPatchSize < FENCE_START){
        weeds[i].drawDandelion(shift);
        weeds[i].drawDandelion(shift+weedPatchSize);
      }
      else if(shift < FENCE_START){
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
  
  ////////////////////////////////////////////      STAGE 2       ////////////////////////////////////////////
  else if(gameState == Game.STAGE_2){
    pushMatrix();
    translate(cam.getX(),cam.getY());
    brood[0].drawHomeWeb();
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
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    if(shift >= POND_START - weedPatchSize){
      for(int i = 0; i < lawn.length; i++){
        waterGrass[i].drawGrass(POND_START);
        waterGrass[i].drawGrass(POND_START+grassPatchSize);
        waterGrass[i].drawGrass(POND_START+2*grassPatchSize);
        waterGrass[i].drawGrass(POND_START+3*grassPatchSize);
        waterGrass[i].drawGrass(POND_START+4*grassPatchSize);
      }
      pond.drawPond();
      for(int i = 2; i < waterWeeds.length; i++){
          waterWeeds[i].drawCattail(POND_START);
          waterWeeds[i].drawCattail(POND_START+weedPatchSize);
      }
    }
    rock.drawRock();

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
      if(hero.getPosition().y > -cam.getY()+height && !hero.getWebHeld()){
        hero.fireWeb(hero.getPosition().x, -height/4);
      }
      else if(hero.getPosition().x < FENCE_START + 1.5*fenceWidth && !hero.getWebHeld()){
        hero.fireWeb(FENCE_START + 2*fenceWidth, -height/4); 
      }
      else if(hero.getPosition().x > FENCE_START + 1.5*fenceWidth + width && !hero.getWebHeld()){
        hero.fireWeb(FENCE_START + fenceWidth + width, -height/4); 
      }
    }

    hero.drawHero();
    hero.update();
    if(hero.getWound() > 0){
      fill(255,0,0, hero.getWound());
      rect(-cam.getX(),-cam.getY(),width, height);
      hero.decrementWound(30);
    }
    popMatrix();
    
    if(cam.getY() >= height/2){
      if(cat.insideRange(hero.getPosition(), hero.getSize())){
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
    if(clock.getElapsedTime() > 5000 && cam.getY() < height/2 && waiting){
      cam.moveUp();
      if(cam.getY() >= height/2){
        dialog.setText(stageTwoText[1]);
        clock.startTime();
      }
    }
    else if(clock.getElapsedTime() > 5000 && cam.getY() >= height/2 && !hero.catFollowing){  //cat enters meow
      dialog.setVisibility(false); 
      hero.toggleCatFollowing();
      yowl.trigger();
    }
    dialog.display();
  }
    ////////////////////////////////////////////      STAGE 3       ////////////////////////////////////////////
  else if(gameState == Game.STAGE_3){ 
    pushMatrix();
    translate(cam.getX(),cam.getY());
    shift = floor(-cam.getX()/grassPatchSize)*grassPatchSize;  
    for(int i = 0; i < lawn.length; i++){
      waterGrass[i].drawGrass(shift);
      waterGrass[i].drawGrass(shift+grassPatchSize);
      waterGrass[i].drawGrass(shift+2*grassPatchSize);
      waterGrass[i].drawGrass(shift+3*grassPatchSize);
      waterGrass[i].drawGrass(shift+4*grassPatchSize);
    }
    pond.drawPond();
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 2; i < waterWeeds.length; i++){
            waterWeeds[i].drawCattail(shift);
            waterWeeds[i].drawCattail(shift+weedPatchSize);
    }
    rock.drawRock();
    for(int i = 0; i < pads.length; i++){
      pads[i].drawLillyPad();
    }
    waterWeeds[0].drawCattail(POND_FINAL - width/2);
    waterWeeds[1].drawCattail(POND_FINAL + width/2);
    for(int i = 0; i < frogs.length; i++){
      frogs[i].drawFrog();
      frogs[i].update();
      if(i >= 2 && hero.getPosition().x < POND_FINAL){
        frogs[i].checkRange(hero.getPosition(), hero.getSize());
      }
    }
    int count = 0;
    for(int i = 0; i < butterflies.length; i++){
      butterflies[i].drawButterfly();
      butterflies[i].update(hero.getPosition());
      if(butterflies[i].getCaught()){
        count++;
        if(count == butterflies.length){
          gameState = Game.FINAL;
          hero.clearOldWeb();
          generateEndScreen();
          hero.toggleFinalText();
          clock.startTime();
          waiting = true;
        }
      }
      frogs[0].checkRange(butterflies[i].getPosition(), butterflies[i].getSize());
      frogs[1].checkRange(butterflies[i].getPosition(), butterflies[i].getSize());
    }
    
    hero.drawHero();
    hero.update();
    if(hero.getPosition().x > POND_FINAL){
      hero.setGroundLevel(pads[0].getPosition().y-hero.getSize());
      hero.setPos(POND_FINAL, hero.getPosition().y);
      hero.releaseWeb();
      dialog.setText(stageThreeText[0]);
      dialog.setSize(24); 
      dialog.setVisibility(true); 
      clock.startTime();
      waiting = true;
    }
    else if(hero.getPosition().x < POND_FINAL && hero.getPosition().y > pond.waterLevel()){
      hero.takeDamage();
    }
    popMatrix();
    
    if(-cam.getX() < POND_FINAL-width/2){
      if(hero.getPosition().x == POND_FINAL){
        cam.moveRight(.5);
      }
      else{
        cam.lockOnTo(hero.getPosition().x);
      }
    }
    else{
      cam.setPos(POND_FINAL-width/2, 0);
    }
    
    ///////////////////////Dialog handling////////////////////////////////
    if(hero.getPosition().x == POND_FINAL){
      if(clock.getElapsedTime() > 15000 && waiting){
        waiting = false;
        dialog.setVisibility(false); 
        for(int i = 0; i < butterflies.length; i++){
          butterflies[i].removeLimits();
        }
        clock.startTime();
      }
      if(!roundUp && clock.getElapsedTime() > 60000 && !waiting){
        roundUp = true;
        dialog.setText(stageThreeText[1]);
        dialog.setVisibility(true); 
      }
      dialog.display();
    }
  }
  /////////////////////////////////////// Stage Final ////////////////////////////////////////////
  else if(gameState == Game.FINAL){
    pushMatrix();
    translate(cam.getX(),cam.getY());
    for(int i = 0; i < sky.length; i++){
      sky[i].drawCloud();
    }
    for(int i = 0; i < skyCredits.length; i++){
      skyCredits[i].drawCloud();
    }
    shift = floor(-cam.getX()/grassPatchSize)*grassPatchSize;  
    for(int i = 0; i < lawn.length; i++){
      waterGrass[i].drawGrass(shift);
      waterGrass[i].drawGrass(shift+grassPatchSize);
      waterGrass[i].drawGrass(shift+2*grassPatchSize);
      waterGrass[i].drawGrass(shift+3*grassPatchSize);
      waterGrass[i].drawGrass(shift+4*grassPatchSize);
    }
    pond.drawPond();
    shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    for(int i = 2; i < waterWeeds.length; i++){
            waterWeeds[i].drawCattail(shift);
            waterWeeds[i].drawCattail(shift+weedPatchSize);
    }
    for(int i = 0; i < pads.length; i++){
      pads[i].drawLillyPad();
    }
    waterWeeds[0].drawCattail(POND_FINAL - width/2);
    waterWeeds[1].drawCattail(POND_FINAL + width/2);
    for(int i = 0; i < frogs.length; i++){
      frogs[i].drawFrog();
      frogs[i].update();
    }
    endLeft.display();
    endRight.display();
    popMatrix();
    if(waiting && (-cam.getY() < -height)){
      waiting = false;
      println(-cam.getY());
      hero.speechBubbleSwitch(false);
    }
    if(-cam.getY() > -8.2*height){
      cam.moveUp();
    }
    pushMatrix();
    translate(cam.getX(), 0);
    for(int i = 0; i < butterflies.length; i++){
      butterflies[i].drawButterfly();
      butterflies[i].update(hero.getPosition());
    }
    
    hero.drawHero();
    hero.update();
    popMatrix();
    

  }
  ///////////////////////////////////////// Game Over //////////////////////////////////////////////
  else if(gameState == Game.OVER){
   generateGameOverScreen();
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
  if(gameState == Game.STAGE_1){
    float shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    float patch = ((mouseX - cam.getX()) < shift + weedPatchSize) ? 0 : weedPatchSize;
    for(int i = 0; i < weeds.length; i++){ 
      if(weeds[i].hitDandelion(mouseX-cam.getX(), mouseY+cam.getY(), shift, patch)){
        hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
      }
    }
  }
  if(gameState == Game.STAGE_2 || gameState == Game.STAGE_1){
    for(int i = 0; i < fence.length; i++){
      if(fence[i].hitFence(mouseX - cam.getX(), mouseY-cam.getY())){
        hero.fireWeb(mouseX-cam.getX(), mouseY-cam.getY());
      }
    }
  }
  if(gameState == Game.STAGE_2){
    float shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
    float patch = ((mouseX - cam.getX()) < shift + weedPatchSize) ? 0 : weedPatchSize;
    for(int i = 0; i < waterWeeds.length; i++){
      if(waterWeeds[i].hitCattail(mouseX-cam.getX(), mouseY+cam.getY(), shift, patch)){
        hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
      }
    }
  }
  if(gameState == Game.STAGE_3){
    if(hero.getPosition().x < POND_FINAL){
      float shift = (floor(-cam.getX()/weedPatchSize)*weedPatchSize);
      float patch = ((mouseX - cam.getX()) < shift + weedPatchSize) ? 0 : weedPatchSize;
      for(int i = 0; i < waterWeeds.length; i++){
        if(waterWeeds[i].hitCattail(mouseX-cam.getX(), mouseY+cam.getY(), shift, patch)){
          hero.fireWeb(mouseX-cam.getX(), mouseY+cam.getY());
        }
      }
    }
    else if(hero.getPosition().x == POND_FINAL  && gameState != Game.FINAL){
      if(waiting && clock.getElapsedTime() > 5000 && !roundUp){ 
        for(int i = 0; i < butterflies.length; i++){
          butterflies[i].removeLimits();
          println("removed limits");
        }
        waiting = false;
        clock.startTime();
        dialog.setVisibility(false); 
      }
      for(int i = 0; i < butterflies.length; i++){
        if(butterflies[i].hitButterfly(mouseX - cam.getX(), mouseY) && !butterflies[i].getCaught()){
          butterflies[i].leashButterfly(hero.getPosition());
          butterflies[i].setPullPosition(mouseX, mouseY);
          if(roundUp && butterflies[i].insideLimits()){
            butterflies[i].setLimited(true);
            println("Set limited to true");
          }
          break;
        }
      }
    }
  }
}

void mouseReleased(){
  hero.releaseWeb();
  if(gameState == Game.STAGE_3 && !roundUp){
    for(int i = 0; i < butterflies.length; i++){
      if(butterflies[i].getCaught()){
        butterflies[i].setCaught(false);
        butterflies[i].fling(new PVector(mouseX, mouseY));
      }
    }
  }
  else if(gameState == Game.STAGE_3 && roundUp){
    for(int i = 0; i < butterflies.length; i++){
      if(!butterflies[i].insideLimits() && butterflies[i].getCaught()){
        butterflies[i].setCaught(false);
        butterflies[i].fling(new PVector(mouseX, mouseY));
      }
    }
  }
}


void checkInput(){
  if(keys['M'] || keys['m']){
    if(song.isPlaying()){
      song.pause();
    }
    else{
      song.loop();
    }
     keys['M'] = false;
     keys['m'] = false;
  }
  if(keys['P'] || keys['p']){
    save("screenShot.png");
  }
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
  if(keys['B'] || keys['b']){
    cam.moveOut();
  }
  if(keys['F'] || keys['f']){
    cam.moveIn();
  }
  if(keys[' ']){
    hero.retractWeb();
  }
  if(keys['R'] || keys['r']){
    switch(progress){
      case START: 
      case STAGE_1:{
        clock.startTime();
        hero.reset();
        cam.reset();
        mower.reset();
        for(int i = 0; i < bugs.length; i++){
          bugs[i].reset();
        }
        gameState = Game.STAGE_1;
        progress = Game.STAGE_1;
        break;
      }
    case STAGE_2: {
      gameState = Game.STAGE_2;
      progress = Game.STAGE_2;
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
      break;
    }
    case STAGE_3:{
      gameState = Game.STAGE_3;
      progress = Game.STAGE_3;
      for(int i = 0; i < butterflies.length; i++){
        butterflies[i].reset();
      }
      hero.speechBubbleSwitch(false);
      dialog = new Bubble(0, height/6, width, height/6, false);
      dialog.setText(stageThreeText[0]);
      dialog.setSize(24);
      if(hero.getPosition().x == POND_FINAL){    
        hero.setPos(POND_FINAL, 0);
        cam.setPos(POND_FINAL-width/2, 0);
        hero.setGroundLevel(pads[0].getPosition().y-hero.getSize());
        clock.startTime();
        waiting = true;
        dialog.setVisibility(true); 
      }
      else{
        hero.reset();
        hero.setPos(POND_START+width/4, 0);
        cam.setPos(POND_START, 0);
        hero.setGroundLevel(height - grassHeight);
        dialog.setVisibility(false); 
      }
      hero.setHealth(1);
      break;
    }
    case FINAL:{
      gameState = Game.START;
      progress = Game.START;
    }
    default:  break;
    }
    keys['r'] = false; 
    keys['R'] = false;
  }
  
  /////////////////////////Testing use only///////////////////////////
  if(keys['i']){
       for(int j = 0; j < butterflies.length; j++){
        println("caught " + butterflies[j].caught);
        println("limited " + butterflies[j].limited);
      }
  }
  if(keys['2']){
    gameState = Game.STAGE_2;
    progress = Game.STAGE_2;
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
  if(keys['3']){
    gameState = Game.STAGE_3;
    progress = Game.STAGE_3;
    hero.speechBubbleSwitch(false);
    hero.setPos(POND_START+width/4, 0);
    cam.setPos(POND_START, 0);
    hero.setHealth(1);
    //nature.play();
    keys['3'] = false;
  }
  if(keys['4']){
    gameState = Game.STAGE_3;
    progress = Game.STAGE_3;
    hero.speechBubbleSwitch(false);
    hero.setPos(POND_FINAL, 0);
    cam.setPos(POND_FINAL-width/2, 0);
    hero.setGroundLevel(pads[0].getPosition().y-hero.getSize());
    hero.setHealth(1);
    clock.startTime();
    dialog = new Bubble(0, height/6, width, height/6, false);
    dialog.setText(stageThreeText[0]);
    dialog.setSize(24);
    dialog.setVisibility(true); 
    keys['4'] = false;
  }
  if(keys['5']){
    gameState = Game.STAGE_3;
    progress = Game.STAGE_3;
    hero.speechBubbleSwitch(false);
    hero.setPos(POND_FINAL, 0);
    cam.setPos(POND_FINAL-width/2, 0);
    hero.setGroundLevel(pads[0].getPosition().y-hero.getSize());
    hero.setHealth(1);
    roundUp = true;
    keys['5'] = false;
  }
  if(keys['6']){
    generateEndScreen();
    gameState = Game.FINAL;
    progress = Game.FINAL;
    hero.speechBubbleSwitch(true);
    hero.setPos(POND_FINAL, pads[0].getPosition().y-hero.getSize());
    cam.setPos(POND_FINAL-width/2, 0);
    keys['6'] = false;
  }
    if(keys['7']){
    gameState = Game.OVER;
    hero.toggleGameOverText();
    keys['7'] = false;
  }
}
  
Game checkGameState(){
  if(gameState == Game.START){
    return Game.START;
  }
  else if(gameState == Game.OVER){
    return Game.OVER;
  }
  else if(gameState == Game.STAGE_1){
    float distance = mower.checkDistance(hero.getPosition());
    amplitude = map(distance, 0, width, 250, -30); //neat 
    mowerSound.setGain(amplitude);
    if(distance <= 0){
      mowerSound.pause();
      return Game.OVER;
    }
  }
  else if(gameState == Game.STAGE_2 || gameState == Game.STAGE_3){
    if(hero.getHealth() <= 0){
      return Game.OVER;
    }
  }
  
  ////////////////////Stage Check//////////////////////////////////
  if(gameState == Game.FINAL){
    progress = Game.FINAL;
    return Game.FINAL;
  }
  if(-cam.getX() >= POND_START){
    progress = Game.STAGE_3;
    return Game.STAGE_3;
  }
  if(-cam.getX() >= FENCE_START + 1.5*fenceWidth){
    if(gameState != Game.STAGE_2){
      hero.speechBubbleSwitch(false);
      dialog = new Bubble(0, height/6, width, height/6, false);
      dialog.setText(stageTwoText[0]);
      dialog.setSize(24);
      clock.startTime();
      cat = new Cat(new PVector(FENCE_START - 1.5*fenceWidth,0), height/2);
    }
    progress = Game.STAGE_2;
    return Game.STAGE_2;
  }
  else{
    progress = Game.STAGE_1;
    return Game.STAGE_1;
  }
}

void createAudio(){
  minim = new Minim(this);
  song = minim.loadFile("songOverlay.mp3");
  song.setGain(-30);
  song.loop();
  mowerSound = minim.loadFile("mower.wav");
  nature = minim.loadFile("nature.wav");
  
  grunt = minim.loadSample("grunt.wav");
  meow = minim.loadSample("cat1.wav");
  grumble = minim.loadSample("catGrumble.mp3");
  yowl = minim.loadSample("catEntrance.mp3");
  wee = minim.loadSample("wee.wav");
  woo = minim.loadSample("woo.wav");
  yay = minim.loadSample("yay.wav");
  ok = minim.loadSample("ok.wav");
  frog = minim.loadSample("frog.mp3");
}

void drawSplash(){ 
  image(background,0,0);
  body.display();
  title.display();
}


void generateStartScreen(){
  title = new Bubble(0, height/6, width, height/6, true);
  title.setSize(64);
  title.setText("The Adventures of Spider Bro");
  body = new Bubble(true);
  body.setText("Help Spider Bro protect his friends and complete his missions as a Gaurdian of the Yard. Do your best to help out those in need! \n\n Controls: \n Click and hold inside the dandelion tops to swing. Press SPACE to retract your web faster. \n\n\n\n When you are ready, press 'R' to begin.");
  body.setSize(24);
}

void generateGameOverScreen(){
   background(0,0,0);
   fill(255,0,0);
   textSize(TEXT_SIZE);
   text("Game over! \n Press 'R' to restart. \n\n\n\n Controls: \n Click and hold to swing. \nPress SPACE to retract your web faster.", width/2, height/2.25); 
   fill(SKY);
   noStroke();
   ellipse(width/2, height/2.5, 5*UNIT_SPACING,5*UNIT_SPACING);
   hero.setPos(width/2, height/2.5);
   hero.drawDead();
}

void generateEndScreen(){
  endLeft = new Bubble(POND_FINAL-width/2, -7*height, width/2, height, true);
  endLeft.setSize(35);
  endLeft.setText("Congratulations! \n\n You have successfully completed your duties as a Gaurdian of the Yard!");
  endLeft.setVisibility(true);
  endRight = new Bubble(POND_FINAL, -7*height, width/2, height, true);
  endRight.setText("Press 'R' to return to the start screen.");
  endRight.setSize(24);
  endRight.setVisibility(true);
}

void initializeCloudText(){
  skyCredits[0] = new Cloud(POND_FINAL - width/4, -3*height, height/3);
  skyCredits[0].setText("Brought to you by Justin Wilder.");
  skyCredits[1] = new Cloud(POND_FINAL, -4*height, height/3);
  skyCredits[1].setText("Music by: ");
  skyCredits[2] = new Cloud(POND_FINAL + width/4, -5*height, height/3);
  skyCredits[2].setText("Thank you to my testers: Nick Hyndman, Tory,  ");
}
