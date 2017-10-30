import java.io.*;
import java.net.*;

//Socket s;
//PrintWriter out;
//BufferedReader in;
//int flag = 0;
/*boolean leftBoolean, rightBoolean, speedBoolean;
float speed;
float rot;
float rightBattery;
float leftBattery;
float middleBattery;*/
 
 class Ship {
   
  PVector positionShip;
  //PVector speed;
  float radiusShip, mShip;
  boolean leftBoolean, rightBoolean, speedBoolean;
  float x;
  float y;
  float speed;
  float rot;
  float rightBattery;
  float leftBattery;
  float middleBattery;

  
  Ship(float x, float y, float r_) {
    positionShip = new PVector(x, y);
    //speed = PVector.random2D();
    rightBattery = 100.0;
    middleBattery = 100.0;
    leftBattery = 100.0;
    this.x = x;
    this.y = y;  //ver depois como atualizar a posicao da nave através do erlang
    //speed.mult(3);
    speed = 0;
    rot = 0;
    radiusShip = r_;
    mShip = radiusShip*.1;
  }
  
  
void updateShipp(String[] info){
  
    /*leftBattery = Float.valueOf(info[0]);
    rightBattery = Float.valueOf(info[1]);
    middleBattery = Float.valueOf(info[2]);
    x = Float.valueOf(info[3]);
    y = Float.valueOf(info[4]);
    speed = Float.valueOf(info[5]);
    rot = Float.valueOf(info[6]);
    radiusShip = Float.valueOf(info[7]);
    mShip = Float.valueOf(info[8]);*/
    leftBoolean = Boolean.valueOf(info[9]);
    rightBoolean = Boolean.valueOf(info[10]);
    speedBoolean = Boolean.valueOf(info[11]);
    //updateShip();
  
}
  
void updateShip(){
    positionShip.x +=  cos(rot)*(speed); // current location + the next "step"
    positionShip.y +=  sin(rot)*(speed);
    
    if ((leftBoolean == true) /*&& (leftBattery > .0)*/) {
    rot -= .05;
    //leftBattery -= .5;
    }
    else if ((leftBoolean == true) /*&& (leftBattery == .0)*/) {
    }
    
   
    else if ((rightBoolean == true)/* && (rightBattery > .0)*/) {
      rot += .05;
     // rightBattery -= .5;
    } 
      else if ((rightBoolean == true) /*&& (rightBattery == .0)*/) {
    } 
  else if ((speedBoolean == true) /*&& (middleBattery >= .0)*/) { 
    speed += .1;
   // middleBattery -= .5;
  }
  else if ((speedBoolean == true) /*&& (middleBattery >= .0)*/) { 
  }
  else {
    speed -= .25;
  }
  
  /*if( == false) leftBattery += .5;
  if(rightBoolean == false) rightBattery += .5;
  if(speedBoolean == false) middleBattery += .5;*/
  
  speed = constrain(speed, 0, 4);
}
  
  
void DesenharNave() {
  positionShip.x +=  cos(rot)*(speed); // current location + the next "step"
  positionShip.y +=  sin(rot)*(speed);
  fill(65, 250, 255);
  pushMatrix();
  translate(positionShip.x, positionShip.y); 
  rotate(rot); 
   triangle(0, 0, -30, 20, -30, -20);
   fill(255, 10, 50);
   rect(-38, 12  , 8, 8);
   rect(-38, 0, 8, 8);
   rect(-38, -12, 8, 8); 
  popMatrix();   

  if (leftBoolean == true) {
    rot -= .05;
  } 
  else if (rightBoolean == true) {
    rot += .05;
  } 
  if (speedBoolean == true) { 
    speed += .1;
  }
  else {
    speed -= .25;
  }
  speed = constrain(speed, 0, 4);
}
   
   
 /*Ship clone(){
    return new Ship(this); 
 }*/
 
//}
}   