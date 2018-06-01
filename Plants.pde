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
  
 void drawDandelion(){
   noStroke();
   fill(35,255,35);
   rect(xPos-thickness/2, yPos, thickness, height);
   fill(25,205,25);
   ellipse(xPos, yPos, thickness*1.5, thickness*1.5);
   fill(255, 255, 255, 100);
   ellipse(xPos, yPos, size, size);
 }
 
 boolean hitDandelion(float x, float y){
   if(dist(x,y, xPos, yPos) <= size/2){
     return true;
   }
   return false;
 } 
}

class Grass{
  public static final float grassWidth = 10;
  float grassHeight;
  float[] coords;
  int index;
  
  Grass(float tall, int place){
    grassHeight = tall;
    index = place;
  }
  
  void drawGrass(float shift){
    fill(50,100,50);
    pushMatrix();
    translate(shift, 0);
    quad(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5], coords[6], coords[7]);
    popMatrix();
  }

  void generateGrass(){
    coords = new float[]{index*grassWidth, float(height), (index+1)*grassWidth, float(height), (index+1)*grassWidth, height-random(grassHeight/2, grassHeight), index*grassWidth, height-random(grassHeight/2, grassHeight)}; 
  }
}
