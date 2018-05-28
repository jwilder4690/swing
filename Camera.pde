class Camera{
  PVector pos;
  float vel;
  PVector focus;
  boolean aligned = false;
  
  Camera(){
    this(0.0,0.0);
  }
  Camera(float x,float y){
    pos = new PVector(x,y);
    focus = pos;
    vel = 5;
  }
  
  void changeFocus(PVector aim){
    focus = new PVector(aim.x - width/2, 0);
    aligned = false;
  }
  
  void snapToFocus(float aimX){
    pos.x = aimX;
  }
  
  void update(){
    if(!aligned){
    float dist = pos.dist(focus);
    PVector direction = PVector.sub(focus, pos);
    direction.normalize();
    
    pos.add(direction.mult(vel)); 
    if(pos.dist(focus) < vel){
      aligned = true;
    }
    }
  }
  
  float getX(){
    return -pos.x;
  }
  float getY(){
    return -pos.y;
  }
  
  void moveLeft(){
    pos.x -= vel;
  }
  
  void moveRight(){
    pos.x += vel;
  }
  
  void moveUp(){
    pos.y -= vel;
  }
  
  void moveDown(){
    pos.y += vel;
  }
}
