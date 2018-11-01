class Clock{

  int startTime = 0;
  int elapsedTime = 0;
  boolean stopped = false;
  
  Clock(){
  }
  
  void startTime(){
    startTime = millis();
    stopped = false;
  }
  
  void setTime(int hold){
    stopped = true;
    elapsedTime = hold;
  }
  
  int getElapsedTime(){
    if(!stopped){
      elapsedTime = millis() - startTime;
    }
    return elapsedTime;
  }
}
