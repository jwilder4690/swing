class Camera{
  PVector pos;
  float vel = 8;
  PVector focus;
  boolean locked = true;
  
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
  
  void setPos(float x, float y){
    pos.set(x,y);
  }
  
  boolean getLocked(){
    return locked;
  }
  
  void setVelocity(float rate){
    vel = rate;
  }
    
  void lockOnTo(float heroX){
    pos.x = heroX - width/2;
  }
    
  void moveLeft(){
    pos.x -= vel;
  }
  
  void moveRight(){
    pos.x += vel;
  }
  
  void moveRight(float speed){
    pos.x += speed;
  }
  
  void moveUp(){
    pos.y -= vel;
  }
  
  void moveDown(){
    pos.y += vel;
  }
  
  void reset(){
    pos = new PVector(0,0);
  }
}
