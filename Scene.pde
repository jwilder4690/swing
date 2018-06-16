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
  
  Mower(float x, float y, float big){
    pos = new PVector(x,y);
    startPos = new PVector(x,y);
    angle = 0;
    size = big;
  }
  
  float getVelocity(){
    return velocity;
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
  
  float checkDistance(PVector heroPos){
    float distance = heroPos.dist(pos);
    return distance - (size/2);    
  }
  
  void update(){
    angle += velocity/size;
    pos.add(velocity,0);
    velocity += acceleration;
    if(clock.getElapsedTime() > 15000){
      acceleration = 0.005; 
      if(clock.getElapsedTime() >37000){
        acceleration = -0.1;
        //acceleration = 0;
        //velocity = 7.5;
        if(clock.getElapsedTime() > 45000){
          acceleration = 0;
          velocity = 8;
          println(hero.getPosition());
        }
      }
    }
  }
  
  void reset(){
    mowerSound.stop();
    pos = new PVector(startPos.x, startPos.y);
    angle = 0;
    acceleration = 0;
    velocity = 8;
    mowerSound.loop();
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

  PVector pos;
  PVector vel;
  float size = 5;
  float scale; 
  float[] bounds;
  float speed;
  float max;
  color bodyColor = color(0,0,0);
  float downwardInfluence = 0;
  
  Spider(float x, float y, boolean mom, float a, float b, float c, float d){
    pos = new PVector(x,y);
    println("Spider pos: "+ pos);
    vel = new PVector(0,0);
    if(mom){
      scale = 3;
      max = 2;
      speed = .1;
    }
    else{
      scale = 1;
      speed = .2;
      max = 3;
    }
    bounds = new float[] {a,b,c,d};
    println(bounds);
  }
  
  void drawSpider(){
    pushMatrix();
    translate(pos.x, pos.y);
    println("x: " + pos.x + " y: " + pos.y);
    //scale(scale);
    fill(bodyColor);
    ellipse(0,0,size,size);
    popMatrix();    
  }
  
  void update(){
    println("Pos before vel: " + pos + " Vel: " + vel);
    pos.add(vel);
    println("Pos after vel: " + pos);
    
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
    if(pos.y > bounds[3]){
      pos.y = bounds[3];
      vel.y = -vel.y;
    }
    
    
    vel.x = constrain(vel.x + random(-speed, speed), -max, max);
    vel.y = constrain(vel.y + random(-speed, speed) + downwardInfluence, -max, max);
  }
  
  void increaseInfluence(){
    downwardInfluence += .1;
  }
  
  void drawWeb(float x, float y, float size){
    stroke(55,55,55);
    noFill();
    ellipse(x,y, size, size);
  }
  
  
  
}
