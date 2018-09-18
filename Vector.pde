float angleBetweenVectors(PVector a, PVector b){
  //println("A: "+ a + ", B: " + b);
  
  //return tan((b.y - a.y)/(b.x - a.x));
  //return cos((b.x - a.x)/PVector.dist(a,b));
  
  return sin(-(a.y - b.y)/PVector.dist(a,b));
}
