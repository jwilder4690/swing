class Tree{
  float xPos;
  float yPos;
  int size;
  int thickness;
  
  Tree(float x, float y,int size){
    xPos = x;
    yPos = y;
    this.size = size;
    thickness = size/4;
  }
  
 void drawTree(){
   noStroke();
   fill(155, 100, 75);
   rect(xPos-thickness/2, yPos, thickness, height);
   fill(25,155,25);
   ellipse(xPos, yPos, size, size);
 }
 
 boolean hitTree(float x, float y){
   if(dist(x,y, xPos, yPos) <= size/2){
     return true;
   }
   return false;
 }
  
}
