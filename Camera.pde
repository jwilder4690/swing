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
  
  void changeFocus(float x, float y){
    focus = new PVector(x - width/2, y - height/2);
    aligned = false;
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
