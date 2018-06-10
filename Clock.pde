class Clock{

  int startTime = 0;
  int elapsedTime = 0;
  
  Clock(){
  }
  
  void startTime(){
    startTime = millis();
  }
  
  int getElapsedTime(){
    elapsedTime = millis() - startTime;
    return elapsedTime;
  }
}
