public class Tuplo { 
  public Ship s; 
  public int n; 
  
  public Tuplo(Ship s, int n) { 
    this.s = s; 
    this.n = n; 
  } 
  
  Ship getShip(){
    return s;
  }
  
  void setShip(Ship s){
    this.s = s; //clone !!!
  }
  
  int getOn(){
    return n;
  }
  
  void setOn(int n){
    this.n = n;
  }
  
} 