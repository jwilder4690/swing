class Web{
  final int MINIMUM_LENGTH = 10;
  PVector start;
  PVector end;
  PVector prev;
  float angle = 0;
  float angularVel = 0;
  float angularAcc = 0;
  float retractSpeed = 3;
  float size = 0;
  float gravityConstant = 0.8;
  float damping = 0.95;

Web(){
  this(0.0, 0.0, 0.0, 0.0);
}
Web(float startX, float startY, float endX, float endY){
  start = new PVector(startX, startY);
  end = new PVector(endX, endY);
  prev = start;
}

void drawWeb(){
  stroke(75,75,75);
  line(start.x, start.y, end.x, end.y);
}

void update(){
  start.x = end.x + size * sin(angle);
  start.y = end.y + size * cos(angle);
  
  angularAcc = (-1 * gravityConstant/size) * sin(angle);
  angularVel += angularAcc;
  angularVel *= damping;
  angle += angularVel;
}

PVector update(float damp){
  prev = new PVector(start.x, start.y);
  start.x = end.x + size * sin(angle);
  start.y = end.y + size * cos(angle);
  
  angularAcc = (-1 * gravityConstant/size) * sin(angle);
  angularVel += angularAcc;
  angularVel *= damp;
  angle += angularVel;
  
  return new PVector(start.x, start.y);
}

PVector getTrajectory(){
  PVector out = PVector.sub(start,prev);
  out.normalize();
  return out;
}

float getLinearVelocity(){
  return abs(angularVel * size);
}

void shortenWeb(){
  size -= retractSpeed;
  if(size < MINIMUM_LENGTH){
    size = MINIMUM_LENGTH;
  }
  else{
    angularVel += angularAcc;  //speeds up rotation when retracting
  }
}

void setAngle(){
  size = start.dist(end);
  float deltaX = start.x - end.x;
  angle = sin(deltaX/size); 
  if(start.y < end.y){
    angle = PI-angle;
  }  
}


}
