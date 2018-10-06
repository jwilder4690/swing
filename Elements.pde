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
 
 boolean hitDandelion(float x, float y, float shift, float weedPatch){
   if(dist(x,y, xPos+shift+weedPatch, yPos) <= this.size/2){
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
  
  float getCenter(){
    return xPos + wide/2;
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
    stemColor = color(75, 200, 135);
    topColor = color(152, 101, 50);
    stemLength = height;
 }
 
   boolean hitCattail(float x, float y, float shift, float weedPatch){ //shift? weedPatchSize? 
    if(x < xPos+shift+weedPatch || x > xPos+shift+weedPatch+wide){
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
  
  PVector getPosition(){
    return pos;
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

class Butterfly{
  final int FLUTTER_MAX = 35;
  final int MAX_VELOCITY = 20;
  final float VELOCITY = width/400;
  final float DECAY_RATE = 0.1;
  final int LIMIT = width/5;
  float decay = 0;
  PVector pos;
  PVector vel; 
  PVector pullPosition;
  float flutter = 0;
  float flap;
  float flapRate = 0.25;
  int flapDirection = -1;
  int size;
  int direction;
  color hit = color(255, 0,0);
  color wingColor = color(255, 140,0);
  color wingColor2 = color(255,215,0);
  color bodyColor = color(152, 101, 50);
  Web leash = new Web();
  boolean caught = false;
  boolean flung = false;
  boolean dead = false;
  boolean limited = true;
  
  Butterfly(float x, float y, int big, int way){
    pos = new PVector(x,y);
    size = big;
    direction = way;
    vel = new PVector(VELOCITY,0);
    flap = random(1);
  }
  
  boolean getDead(){
    return dead;
  }
  
  PVector getPosition(){
    return new PVector(pos.x, pos.y + flutter + size/2);
  }
  
  float getSize(){
    return (3*size)/4;
  }
  
  boolean getCaught(){
    return caught;
  }
  
  void setDead(){
    dead = true;
  }
  
  void removeLimits(){
    limited = false;
  }
  
  void setLimited(boolean flag){
    limited = flag;
  }
  
  void setCaught(boolean status){
    caught = status;
  }
  
  void setPullPosition(float mx, float my){
    pullPosition = new PVector(mx,my);
  }
  
  void drawButterfly(){
    noStroke();
    pushMatrix();
    translate(pos.x, pos.y + flutter);
    scale(direction, 1);
    rotate(-PI/4);
        
    ////far wings
    pushMatrix();
    translate(size/4,3*size/4);
    scale(1,flap+flapRate);
    fill(wingColor2);
    rect(-1.2*size,0, size,-size/2);
    arc(-0.3*size, -size/2, size, 1.2*size, HALF_PI + PI/8, TWO_PI + HALF_PI - PI/7, CHORD);
    arc(-size, -size/2, 0.7*size, size, HALF_PI + PI/9, TWO_PI + HALF_PI - PI/8, CHORD);
    popMatrix();
    
    ////close wings
    pushMatrix();
    translate(size/4,3*size/4);
    scale(1,flap);
    fill(wingColor);
    rect(-1.2*size,0, size,-size/2);
    arc(-0.3*size, -size/2, size, 1.2*size, HALF_PI + PI/8, TWO_PI + HALF_PI - PI/7, CHORD);
    arc(-size, -size/2, 0.7*size, size, HALF_PI + PI/9, TWO_PI + HALF_PI - PI/8, CHORD);
    popMatrix();
    
    ///body
    fill(bodyColor);
    ellipse(-size/2,3*size/4, 1.5*size, size/8);
    ellipse(size*.3, 3*size/4, size/5.5, size/5.5);
    popMatrix();
    
    if(caught){
      leash.drawWeb();
    }
  }
  
  void update(PVector heroPos){
    
    //flap update constantly
    flap += flapDirection*flapRate;
    if(flap <= 0 || flap >= 1){
      flapDirection *= -1;
    }
    
    if(!flung){
      if(random(1) > 0.95){
        direction *= -1;
      }
      if(random(1) > 0.95){
        vel.y = -vel.y;
      }
      vel.y += 2*GRAVITY;
      flutter -= vel.y;
      if(flutter >= FLUTTER_MAX){
        //flap wings
        vel.y = 10;
      }      
      if(caught && !limited){
        if(pos.x > heroPos.x){
          pos.x -= vel.x;
        }
        else if(pos.x < heroPos.x){
          pos.x += vel.x;
        }    
      }
      else{
        pos.x = pos.x + (direction*vel.x);
        if(limited){
          if(!insideLimits()){
            direction = -direction;
            pos.x += (direction*vel.x);
          }
        }
      }
    }
    else if(flung){
      pos.x = pos.x + (direction*vel.x);
      if(vel.x > VELOCITY){
        vel.x -= decay;
        decay += DECAY_RATE;
      }
      else{
        flung = false;
      }
    }
    
    if(caught){
      leash.setEnd(pos.x, pos.y + flutter + size);
    }
  }
  
  void fling(PVector mouse){
    flung = true;
    decay = 0;
    float dist = mouse.dist(pullPosition);
    float newVel = map(dist, 0, width, VELOCITY, MAX_VELOCITY);
    if(mouse.x < pullPosition.x){
      direction = -1;
    }
    else if(mouse.x > pullPosition.x){
      direction = 1;
    }
    vel.x = newVel;
  }
  
  boolean insideLimits(){
    if(pos.x < POND_FINAL + LIMIT && pos.x > POND_FINAL - LIMIT){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean hitButterfly(float x, float y){
    if(dist(x,y, pos.x, pos.y + flutter + size/2) < .75*size){ //hit box is slightly offset from pos.x
      return true;
    }
    return false;    
  }
  
  void leashButterfly(PVector heroPos){
    caught = true;
    leash = new Web(heroPos.x, heroPos.y, pos.x, pos.y + flutter + size);
  }

  void reset(){
    pos.set(POND_FINAL, height/3);
    caught = false;
    flung = false;
    dead = false;
    limited = true;
  }
}

class Rock{
  PVector pos;
  color shade = color(175,175,175);
  int size;
  
  Rock(float x, float y, int big){
    pos = new PVector(x,y);
    size = big;
  }
  
  void drawRock(){
    fill(shade);
    ellipse(pos.x, pos.y, 1.5*size, size);
  }
}

class Cloud{
 PVector pos;
 color shade = color(255,255,255);
 float size;
 float sizeA, sizeB, sizeC, sizeD, sizeE;
 color textColor = color(0,0,0);
 boolean textCloud = false;
 String message = "";
 
 Cloud(float x, float y, float big){
   pos = new PVector(x,y);
   size = big;
   sizeA = random(0.5*size, 0.75*size);
   sizeB = random(0.75*size, 0.25*size);
   sizeE = random(0.75*size, 0.25*size);
   sizeC = random(0.5*size, size);
   sizeD = random(0.5*size, size); 
 }
 
 void setText(String text){
  message = text;
  textCloud = true;
 }
 
 void drawCloud(){
   noStroke();
   fill(shade);
   pushMatrix();
   translate(pos.x, pos.y);
   ellipse(0,0, size, size);
   ellipse(0,0, size+sizeB+sizeE, sizeA);
   ellipse(-size/2 - sizeB/2, 0, sizeB, sizeB);
   ellipse(size/2 + sizeE/2, 0, sizeE, sizeE);
   ellipse(-sizeC/2, -sizeA/2, sizeC, sizeC);
   ellipse(sizeD/2, -sizeA/2, sizeD, sizeD);
   if(textCloud){
     fill(textColor);
     text(message, 0,-sizeA/4);
   }
   popMatrix();
 }
 
}
