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

class Frog{
  final int SITTING = 1;
  final int CLIMBING = 0;
  PVector pos;
  float range;
  int headSize;
  float angle;
  color skin = color(50, 255, 100);
  color tongueColor = color(255, 155, 205);
  PVector tonguePosition;
  int tongueSize;
  //PVector targetPosition;
  boolean attacking = false;
  boolean retracting = false;
  int tongueSpeed = 25;
  PVector aim;
  int type;
  PVector prey;
  float preySize; 
  
  Frog(float x, float y, int big,int style){
    pos = new PVector(x,y); 
    headSize = big;
    tongueSize = headSize/2;
    angle = 0;
    tonguePosition = new PVector(0,0);
    aim = new PVector(0,0);
    prey = new PVector(0,0);
    type = style;
    range = (type == CLIMBING) ? 5*headSize : 15*headSize;
  }
  
  PVector getPosition(){
    return pos;
  }
  
  PVector getTonguePosition(){
    return tonguePosition;
  }
  
  void drawFrog(){
    pushMatrix();
    translate(pos.x, pos.y);
    //HEAD
    pushMatrix(); 
    fill(tongueColor);
    ellipse(tonguePosition.x, tonguePosition.y, tongueSize, tongueSize);
    stroke(tongueColor);
    strokeWeight(7);
    line(0,0, tonguePosition.x, tonguePosition.y);
    noStroke();
    strokeWeight(2);
     fill(skin);
    if(type == CLIMBING){
      rotate(angle);
      arc(0,0, headSize, headSize, PI/8,  TWO_PI - PI/8, PIE);
    }
    else if(type == SITTING){
      ellipse(0,0, headSize, headSize);
    }
    popMatrix();
    
    //BODY
    if(type == CLIMBING){
      ellipse(0, 1.4*headSize, 1.5*headSize, 2*headSize);
    }
    else if(type == SITTING){
      ellipse(0, headSize, 1.3*headSize, 1.4*headSize);
      pushMatrix();
      translate(0.8*headSize, headSize);
      rotate(PI/6);
      ellipse(0,0, headSize/2, 1.4*headSize);
      popMatrix();
      pushMatrix();
      translate(-0.8*headSize, headSize);
      rotate(-PI/6);
      ellipse(0,0, headSize/2, 1.4*headSize);
      popMatrix();
    }
    popMatrix();
  }
  
  void update(){
    if(attacking && !retracting){
      tonguePosition.add(aim);
      if(tonguePosition.mag() > range){
        retracting = true; 
      }
    }
    else if(retracting){
      tonguePosition.sub(aim);
      if(tonguePosition.x <= 0){
        tonguePosition.x = 0;
        tonguePosition.y = 0;
        attacking = false;
        retracting = false;
      }
    }
    //if(attacking){
    //  if(tongueHit(hero.getPosition())){
    //    hero.takeDamage(); //causes game over
    //  }
    //}
  }
  
  
  void checkRange(PVector target, float size){
    if(!attacking){
      if(target.dist(pos) - size <= 2*range){
        prey = target;
        preySize = size;
        launchTongue(target);
      }
    }
    else if(attacking){
      if(tongueHit(target)){
        hero.takeDamage(); //causes game over
      }
    }
  }
  
  void launchTongue(PVector target){
    attacking = true;
    aim = PVector.sub(target,pos);
    angle = PVector.angleBetween(aim, new PVector(1,0));
    if(pos.y - target.y > 0){
      angle = -angle;
    }
    aim.normalize();
    aim.mult(tongueSpeed);
  }
  
  boolean tongueHit(PVector target){
    if(target.dist(PVector.add(tonguePosition, pos)) <= preySize/2 + tongueSize/2){
      return true;
    }
    else{
      return false;
    }
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
