class Vine{
  PVector start;
  PVector end;
  float startAngle;
  float angleVel = PI/64;
  float rotation = 0;
  boolean falling = false;
  float size = 0;

Vine(){
  this(0.0, 0.0, 0.0, 0.0);
}
Vine(float startX, float startY, float endX, float endY){
  start = new PVector(startX, startY);
  end = new PVector(endX, endY);
}

void drawVine(){
  if(falling){
    pushMatrix();
    translate(end.x, end.y);
    rotate(-rotation);
    stroke(0,255,0);
    line(0, 0, 0, size);
    popMatrix();
  }
  else{
    stroke(0,255,0);
    line(start.x, start.y, end.x, end.y);
  }
}

void update(){
  
}

void fall(){
  rotation -= angleVel;
  if(abs(rotation) > abs(startAngle)){
    angleVel = -angleVel;
    startAngle -= angleVel;
  }
}

void setFalling(){
  falling  = true;
}

void setAngle(){
  float dist = start.dist(end);
  float deltaX = start.x - end.x;
  startAngle = (deltaX/dist);  //sin theta is close to theta for small angles
  size = dist;
}


}
