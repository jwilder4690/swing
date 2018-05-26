class Camera{
  PVector pos;
  float vel;
  PVector focus;
  
  Camera(){
    this(0.0,0.0);
  }
  Camera(float x,float y){
    pos = new PVector(x,y);
    focus = pos;
    vel = 5;
  }
  
  void changeFocus(PVector target){
    focus = target;
  }
  
  void update(){
    float dist = pos.dist(focus);
    PVector direction = PVector.sub(focus, pos);
    direction.normalize();
    
    pos.add(direction.mult(vel));  
  }
  
  float getX(){
    return pos.x;
  }
  float getY(){
    return pos.y;
  }
  
  void moveLeft(){
    pos.x -= vel;
  }
}
