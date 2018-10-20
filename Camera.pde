class Camera{
  
  final int MAX_VELOCITY = 10;
  PVector pos;
  float vel = 8;
  float acceleration = .4;
  float adjust;
  PVector focus;
  boolean locked = true;
  float location;
  
  Camera(){
    this(0.0,0.0);
  }
  Camera(float x,float y){
    pos = new PVector(x,y);
    focus = pos;
  }
     
  float getX(){
    return -pos.x;
  }
  float getY(){
    return -pos.y;
  }
  float getZ(){
    return -pos.z;
  }
  
  void setPos(float x, float y){
    pos.set(x,y);
  }
  
  boolean getLocked(){
    return locked;
  }
  
  void setVelocity(float rate){
    vel = rate;
  }
  
  void accelerate(float adjust){
    vel += adjust;
    if(vel < 0) vel = 0;
    if(vel > MAX_VELOCITY) vel = MAX_VELOCITY;
  }
    
  void lockOnTo(float heroX){
    heroX -= pos.x; //gets screen position
    adjust = map(heroX, 3*width/7, width - width/5, -1.5*acceleration, acceleration);
    accelerate(adjust);
    this.moveRight();

    if(pos.y < 0){
      this.moveDown();
    }
  }
    
  void moveLeft(){
    pos.x -= vel;
  }
  
  void moveRight(){
    pos.x += vel;
  }
  
  void moveRight(float accel){
    pos.x += vel + accel;
  }
  
  void moveUp(){
    pos.y -= vel/2;
  }
  
  void moveDown(){
    pos.y += vel/5;
    if(pos.y > 0){
      pos.y = 0;
    }
  }
  
  void moveOut(){
    pos.z += vel;
  }
  
  void moveIn(){
    pos.z -= vel;
  }
  
  void reset(){
    pos = new PVector(0,0);
  }
}
