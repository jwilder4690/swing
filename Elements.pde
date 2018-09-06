class Dandelion{
  float xPos;
  float yPos;
  int size;
  int thickness;
  
  Dandelion(float x, float y,int size){
    xPos = x;
    yPos = y;
    this.size = size;
    thickness = size/8;
  }
  
 void drawDandelion(float shift){
   noStroke();
   pushMatrix();
   translate(shift,0);
   fill(35,255,35);
   rect(xPos-thickness/2, yPos, thickness, height);
   fill(25,205,25);
   ellipse(xPos, yPos, thickness*1.5, thickness*1.5);
   fill(255, 255, 255, 100);
   ellipse(xPos, yPos, size, size);
   popMatrix();
 }
 
 boolean hitDandelion(float x, float y, float shift){
   if(dist(x,y, xPos+shift, yPos) <= size/2){
     return true;
   }
   else if(dist(x,y, xPos+shift+weedPatchSize, yPos) <= size/2){
     return true;
   }
   return false;
 } 
}

class Cattail{
  color stemColor = color(50, 155, 100);
  color topColor = color(102, 51, 0);
  
  float xPos;
  float yPos;
  float wide;
  float tall;
  float stemLength;
  
  Cattail(float x, float y, float thick){
    xPos = x;
    yPos = y;
    wide = thick;
    tall = thick*3.5;
    stemLength = height - yPos - (random(0.5, 0.7)*grassHeight);
  }
  
  void drawCattail(float shift){
    noStroke();
    pushMatrix();
    translate(shift, 0);
    fill(stemColor);
    rect(xPos + (wide/2-wide/5), yPos - wide/2, 2*wide/5, stemLength);
    ellipse(xPos + wide/2, stemLength+yPos-wide/2, 2*wide/5, wide/5);
    fill(topColor);
    rect(xPos + (wide/2 - wide/10), yPos - tall - wide/2, wide/5, wide, wide/10, wide/10, 0,0);
    rect(xPos, yPos - tall, wide, tall, wide/2,wide/2,wide/2,wide/2);
    popMatrix();
 }
 
 void setForeground(){
    stemColor = color(50, 255, 100);
    topColor = color(152, 101, 50);
    stemLength = height;
    println(xPos);
 }
 
   boolean hitCattail(float x, float y, float shift){ //shift? weedPatchSize? 
    if(x < xPos+shift || x > xPos + shift + wide){
      return false; 
    }
    if(y < yPos - tall || y > yPos){
      return false;
    }
    return true;
  }
 
}

class Fence{
  float xPos;
  float yPos;
  float wide;
  float tall;
  color paint = color(255,255, 225);
  
  Fence(float x, float y){
    this(x,y, fenceWidth, height*1.4);
  }
  Fence(float x, float y, float thick, float high){ //x,y bottom left
    xPos = x;
    yPos = y; 
    wide = thick;
    tall = high;
  }
  
  float[] getCoordinates(){
    return new float[] {xPos, yPos - tall, xPos + wide, yPos};
  }
  
  void drawFence(){
    stroke(55,55,55);
    fill(paint);
    rect(xPos, yPos - tall, wide, tall);
  }
  
  boolean hitFence(float x, float y){
    if(x < xPos || x > xPos + wide){
      return false; 
    }
    if(y < yPos - tall || y > yPos){
      return false;
    }
    return true;
  }
}

class Pond{
  int wide;
  float tall;
  color waterColor = color(0,50,255);
  
  Pond(float high){
    tall = high;
    wide = POND_FINAL - POND_START + width*2;
  }
  
  float waterLevel(){
    return height-tall;
  }
  
  void drawPond(){
    fill(waterColor);
    rect(POND_START, height - tall, wide, tall);
  }
}

class LillyPad{
  PVector pos;
  float angle;
  float wide;
  float tall;
  color shade = color(25, 205, 100);
  
  LillyPad(float x, float y, float size, float rotation){
    pos = new PVector(x,y);
    wide = size;
    tall = size/4;
    angle = rotation;
  }
  
  float getHeight(){
    return pos.y;
  }
  
  void drawLillyPad(){
    pushMatrix();
    translate(pos.x, pos.y);
    fill(shade);
    arc(0,0, wide, tall, angle, angle+(15*PI/8), PIE);
    popMatrix();
  }
}

class Grass{
  public static final float GRASS_WIDTH = 10;
  float grassLength;
  float[] coords;
  int index;
  
  Grass(float tall, int place){
    grassLength = tall;
    index = place;
  }
  
  void drawGrass(float shift){
    noStroke();
    fill(50,100,50);
    pushMatrix();
    translate(shift, 0);
    quad(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
    popMatrix();
  }

  void generateGrass(){
    coords = new float[]{index*GRASS_WIDTH, float(height), (index+1)*GRASS_WIDTH, float(height), (index+1)*GRASS_WIDTH, height-random(grassLength/2, grassLength), index*GRASS_WIDTH, height-random(grassLength/2, grassLength)}; 
  }
}

class Mower{
  public static final int MOWER_SPEED = 8;
  float velocity = 8;
  float acceleration = 0;
  PVector pos;
  PVector startPos;
  float angle;
  float size;
  float startPoint = 0;
  boolean phase1, phase2, phase3;
  
  Mower(float x, float y, float big){
    pos = new PVector(x,y);
    startPos = new PVector(x,y);
    angle = 0;
    size = big;
    phase1 = true;
    phase2 = false;
    phase3 = false;
  }
  
  float getVelocity(){
    return velocity;
  }
  
  float checkDistance(PVector heroPos){
    float distance = heroPos.dist(pos);
    return distance - (size/2);    
  }
  
  void drawMower(){
    noStroke();
    pushMatrix();
    translate(pos.x,pos.y);
    fill(205,25,25);
    rect(0,(-size*0.8)/2, -2000, size*0.8);
    rotate(angle);
    fill(0,0,0);
    ellipse(0,0, size, size);
    fill(185,185,185);
    ellipse(0,0, size*0.85, size*0.85);
    fill(0,0,0);
    ellipse(0,0,size*.25, size*.25);
    pushMatrix();
    fill(0,0,0);
    translate(0, 0);
    for(int i = 0; i < 24; i++){
      rotate(PI/12);
      rect(-30, (size/2)-5, 60, 20);
    }
    popMatrix();
    popMatrix();
  }
  
  void update(){
    angle += velocity/size;
    pos.add(velocity,0);
    velocity += acceleration;
    if(-cam.getX() > FENCE_START/3 && phase1){
      acceleration = 0.005; 
      phase1 = false;
      phase2 = true;
    }
    if(screenOverlap(-cam.getX()) > width/3 && phase2){
      acceleration = -0.1;
      phase2 = false;
      phase3 = true;
    }
    if(screenOverlap(-cam.getX()) < -width*1.5 && phase3){
      acceleration = 0;
      velocity = 8;
      mowerSound.stop();
      phase3 = false;
    }
  }
  
  float screenOverlap(float camX){     //use arg of zero to maintain original start point
    float overlap = pos.x - camX;
    return  overlap;
  }
  
  void reset(){
    mowerSound.stop();
    pos = new PVector(startPos.x, startPos.y);
    angle = 0;
    acceleration = 0;
    velocity = 8;
    startPoint = 0;
    mowerSound.loop();
    phase1 = true;
    phase2 = false;
    phase3 = false;
  }
}

class Insect{
  PVector pos;
  PVector vel; 
  float groundLevel;
  float jumpStrength;
  int size;
  boolean jumping = false; 
  
  Insect(float x, float y, float jump, int big){
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    jumpStrength = jump;
    groundLevel = y;
    size = big;
  }
  
  void drawInsect(){
    fill(105,30,30);
    ellipse(pos.x, pos.y, size*1.3, size);
  }
  
  void update(){
    vel.y -= GRAVITY;
    pos.add(vel);
    if(pos.y >= groundLevel){
      vel.set(0,0);
      pos.y = groundLevel;
      jumping = false;
    }
  }
  
  void reset(){
    pos.set(random(width),groundLevel);
    vel.set(0,0);
    jumping = false;
  }
  
  void jump(){
    if(!jumping){
      jumping = true;
      vel = new PVector(jumpStrength*1.5,-jumpStrength);
    }
  }

 PVector getPosition(){
   return pos;
 }
}

class Spider{

  Web leash;
  float size = 5;
  int call;
  float scale; 
  float max;
  color bodyColor = color(0,0,0);
  float damping = 0.95;
  boolean mother = false;
  PVector startPos;
  float[] startBounds;
  
  PVector pos;
  PVector vel;
  float[] bounds;
  float limit;
  float speed;
  boolean safe = false;
  float downwardInfluence = 0;
  boolean caught;
  
  
  Spider(float x, float y, boolean mom, float a, float b, float c, float d, int type){
    pos = new PVector(x,y);
    startPos = new PVector(x,y);
    vel = new PVector(0,0);
    if(mom){
      mother = true;
      scale = 3;
      max = 1;
      speed = .1;
      safe = true;
    }
    else{
      scale = 1;
      speed = .2;
      max = 2;
    }
    bounds = new float[] {a,b,c,d};
    startBounds = new float[] {a,b,c,d};
    limit = 8*bounds[3]/9;
    leash = new Web();
    caught = false;
    call = type;
  }
  
  float[] getBounds(){
    return bounds;
  }
  
  void setBounds(float[] newLimits){
    bounds = newLimits;
    safe = true;
  }
  
  PVector getPosition(){
    return pos;
  }
  
  boolean getSafe(){
    return safe;
  }
  
  void setCaught(boolean change){
    caught = change;
  }
  
  void drawSpider(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(scale);
    fill(bodyColor);
    noStroke();
    ellipse(0,0,size,size);
    popMatrix();    

    lowerLimit();  
    //showLimit();
    if(caught){
      leash.drawWeb();
    }
    
  }
  
  void update(){
    if(caught){
      pos = leash.update(damping);
      leash.shortenWeb(); //constantly retracts web
      if(leash.checkRetracted()){
        caught = false;
        safe = true;
        downwardInfluence = 0;
        limit = 0;
      }
    }
    else{
      pos.add(vel);
      
      if(pos.x < bounds[0]){
        pos.x = bounds[0];
        vel.x = -vel.x;
      }
      if(pos.x > bounds[2]){
        pos.x = bounds[2];
        vel.x = -vel.x;
      }
      if(pos.y < bounds[1]){
        pos.y = bounds[1];
        vel.y = -vel.y;
      }
      if(pos.y > bounds[3]-limit){
        pos.y = bounds[3]-limit;
        vel.y = -vel.y;
      }

      
      
      vel.x = constrain(vel.x + random(-speed, speed), -max, max);
      vel.y = constrain(vel.y + random(-speed, speed) + downwardInfluence, -max, max);
      
      if(random(1) > .95){
        vel.y = -vel.y;
      }
      if(random(1) > .95){
        vel.x = -vel.x;
      }
      
      if(random(1) > 0.99 && !safe){
        downwardInfluence += 0.001;
      }
    }
  }
  
  boolean checkCaught(PVector heroPos, int heroSize, PVector momPos) {
    if(pos.dist(heroPos) <= heroSize/2 + size/2 && !caught && !safe){
      caught = true;
      leash = new Web(pos.x, pos.y, momPos.x, momPos.y);
      leash.setAngle();
      switch(call){
        case 0: wee.play(); break;
        case 1: woo.play(); break;
        case 2: yay.play(); break;
        case 3: ok.play(); break;
      }
      
    }
    return caught;
  }
 
  
  void drawHomeWeb(){
    stroke(55,55,55);
    float size = (bounds[2]-bounds[0]);
    noFill();
    ellipse(bounds[0]+size/2, bounds[1]+size/2, size,size);
    ellipse(bounds[0]+size/2, bounds[1]+size/2, size/2,size/2);
    pushMatrix();
    translate(bounds[0]+size/2, bounds[1]+size/2);
    for(int i = 0; i < 8; i++){
      rotate(PI/8);
      line(0, -size/1.4, 0, size/1.4);
    }
    popMatrix();
  }
  
  void lowerLimit(){
    if(limit > bounds[3]/2){
      limit -= 0.5;
    }
    else limit = bounds[3]/2;
  }
  
  void showLimit(){
    stroke(255,0,0);
    fill(255,0,0);
    line(bounds[0],bounds[3]-limit, bounds[2],bounds[3]-limit);
  }
  
  void reset(){
    pos = new PVector(startPos.x, startPos.y);
    vel = new PVector(0,0);
    bounds = startBounds;
    limit = 8*bounds[3]/9;;
    speed = .2;
    safe = false;
    downwardInfluence = 0;
    caught = false;
  }
}

class Cat{
  final int RIGHT_PACE = 1;
  final int LEFT_PACE = -1;
  final int LIMIT = 25;
  int size = 90;
  int swipeRange = size+30;
  color fur = color(200, 100, 0);
  color nose = color(255, 175,175);
  
  PVector pos;
  PVector vel;
  int cooldown = 0;
  PVector pacePoint;
  boolean hunting = true;
  boolean pacing = false;
  int pace = 0;
  int direction = RIGHT_PACE;
  
  

  
  Cat(PVector heroPos, float catHeight){
    pos = new PVector(heroPos.x - fenceWidth, catHeight - size/4);
    vel = new PVector(2,10);
  }
  
  void drawCat(){
    fill(fur);
    pushMatrix();
    translate(pos.x + pace, pos.y);
    scale(direction, 1);
    stroke(0,0,0);
    triangle(- size/4, - (6*size/9), size/7, 0,-(3*size/7), 0);
    ellipse(0, 0, size, size);
    noStroke();
    triangle((3*size/28), -(4*size/7), 0, -size/4, (2*size/7), -size/4);
    stroke(0,0,0);
    //ear lines
    line((3*size/28), -(4*size/7), 0, -size/4);
    line((3*size/28), -(4*size/7), (2*size/7), -size/4);
    //whiskers 
    line(size/2 - 8, -6, (3*size/28), -10);
    line(size/2 - 8, - 3, (3*size/28) - 4, 0);
    line(size/2 - 8, 0, (3*size/28), 10);
    fill(nose);
    triangle(size/2, 2, size/2 - 4, -6, size/2 + 2, -6);
    popMatrix();
  }
  
  PVector getPosition(){
    return pos;
  }
  
  void update(PVector heroPos){
    if(hunting){
      if(abs(pos.x - heroPos.x) < LIMIT){
        pacing = true;
      }
      else{
        pacing = false;
      }
      
      if(pacing){
        pace();
      }
      else{
        if(pos.x > heroPos.x){
          moveLeft();
        }
        else if(pos.x < heroPos.x){
          moveRight();
        }
      }
    }
    else{
      moveLeft();
    }
  }
  
  void pace(){
    if(direction == RIGHT_PACE){
      pace += vel.x;
      if(pace > LIMIT){
        direction = LEFT_PACE;
      }
    }
    else{
      pace -= vel.x;
      if(pace < -LIMIT){
        direction = RIGHT_PACE;
      }
    }
  }
  
  void moveLeft(){
    pos.x -= vel.x*2;
    direction = LEFT_PACE;
  }
  
  void moveRight(){
    pos.x += vel.x*2;
    direction = RIGHT_PACE;
  }
  
  boolean insideRange(PVector heroPos, float heroSize){
    if(pos.dist(heroPos) < swipeRange/2 + heroSize/2){
      return true;
    }
    else return false;
  }
  
  void swipe(){
    if(cooldown == 0){
      cooldown = 60;
      hero.takeDamage();
      meow.play();
    }
    else{
      cooldown--;
    } 
  }
  
  void stopHunting(){
    if(hunting){
      grumble.play();
      hunting = false;
    }
    
  }
  
  void resetCooldown(){
    cooldown = 0;
  }
  
  void reset(PVector heroPos, float catHeight){
    pos = new PVector(heroPos.x - fenceWidth, catHeight - size/4);
    vel = new PVector(2,10);
    hunting = true;
    pacing = false;
    pace = 0; 
    cooldown = 0;
    direction = RIGHT_PACE;
  }
}
