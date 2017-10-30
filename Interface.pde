import controlP5.*;
import java.util.*;
import java.lang.*;

String textValue = "";
Textfield myTextfield;

//Comandos da interface
int login(String user, String pass){
    try{
      StringBuilder stringBuilder = new StringBuilder();
      stringBuilder.append("login");
      stringBuilder.append(" ");
      stringBuilder.append(user);
      stringBuilder.append(" ");
      stringBuilder.append(pass);
      String line = stringBuilder.toString();
      out.println(line);
      out.flush();
         }
         catch(Exception e){
      e.printStackTrace();
      System.exit(0);
      }
      try{
      line = in.readLine();
      String b[] = line.split(" ", 2);
      System.out.println("linha2 : " + b[0] + " / " + b[1]);
      if(b[0].equals("ok")){ 
                username = user;
                password = pass;
                return 1;
      }
      else if(b[1].equals("invalid")) return 0;
      }
      catch(Exception e){
      e.printStackTrace();
      System.exit(0);
      }
      return -1;
      
}
       
      /*int valido = 0;
      for(Cliente c: registos.keySet())
          if(c.user.equals(user)){ valido = 1; break; }
      if(valido == 1){
        Cliente c1 = new Cliente(user, pass);
        Tuplo t = registos.get(c1);
        t.setOn(1);
        registos.put(c1,t);
    }*/


void createAcc(String user, String pass){
    try{
      StringBuilder stringBuilder = new StringBuilder();
      stringBuilder.append("create_account");
      stringBuilder.append(" ");
      stringBuilder.append(user);
      stringBuilder.append(" ");
      stringBuilder.append(pass);
      String line = stringBuilder.toString();
      out.println(line);
      out.flush();
    }catch(Exception e){
      e.printStackTrace();
      System.exit(0);
     }
      try{
      line = in.readLine();
      String b[] = line.split(" ", 2);
      System.out.println("linha1 : " + b[0] + " / " + b[1]);
      }
      catch(Exception e){
      e.printStackTrace();
      System.exit(0);
      }
}
  
  
  
//Mostrar ecrâs de jogo  
void Mostrarloading() {
  image(spacefield, 0, 0, width, height);
  if(OK == true)
  {
    loading = true;
    frameCount = 1;
    OK = false;
  }
  if(loading == false)
  {
    fill(255);
    textAlign(CENTER);
    //text (tx, 150, 150);
  }
  if(loading == true)
  {
    fill(255);
    textAlign(LEFT);
    text ("LOADING " + int((frameCount%301) / 3) + "%", 50, 130);
    rect(48, 138, 204, 24);
    fill(0);
    int fillX = ((frameCount%301) / 3 * 2);
    rect(250, 140, fillX-200, 20);
    if(frameCount%301 == 0)
    {
      state = game_window;
      loading = false;
      t.start();
    }
  }
} 

void Mostrarlogin() {
  image(spacefield, 0, 0, width, height);
  cp5.getController("LOGIN").show();
  cp5.getController("CRIAR NAVE").show();
  cp5.getController("USERNAME").show();
  cp5.getController("PASSWORD").show();
  //cp6.getController("LOGOUT").hide();
}

 void Mostrargame(){
   //cp6.getController("LOGOUT").show();
   image(starfield, 0, 0, width, height);
      fill(255,255,255);
   textAlign(LEFT);
   text("RIGHT BATTERY:" + nave.rightBattery, 30, 90);
   text("MIDDLE BATTERY:" + nave.middleBattery, 30, 110);
   text("LEFT BATTERY:" + nave.leftBattery, 30, 130);
    
   for (Ball b : balls) {
    b.update();
    b.display();
    }
    
    int shipes = 0;
    
    for(Ship s: registos.values()){
      shipes++;
      s.updateShip();
      s.DesenharNave();
    }
    
    /*nave.updateShip();
    nave.DesenharNave();
    */
    //nave.updateBaterias();
    
  balls[0].checkCollision(balls[1]);
  balls[0].checkCollision(balls[2]);
  balls[0].checkCollision(balls[3]);
  balls[1].checkCollision(balls[2]);
  balls[1].checkCollision(balls[3]);
  balls[2].checkCollision(balls[3]);
}
  
// _________________________________________________________________________  
// Criação de butoẽs
void criarBotaoUsername(){
  myTextfield = cp5.addTextfield("USERNAME")
     .setPosition(145,280) 
     .setSize(200,40)
     .setFont(createFont("arial",17))
     .setFocus(true)
     .setAutoClear(false)
     .setColor(color(255,255,255))
     ;
}

void criarBotaoPassword(){ 
  myTextfield.setFocus(true);
  cp5.addTextfield("PASSWORD")
  .setPosition(145,350) 
     .setSize(200,40)
     .setFont(createFont("arial",17))
     .setFocus(true)
     .setColor(color(255,255,255))
     .setAutoClear(false)
     .setPasswordMode(true)
     ;
}

void criarBotaoLogin(){
     cp5.addButton("LOGIN")
     .setValue(0)
     .setPosition(145,240) 
     .setSize(200,28)
     .setFont(font)
     .onPress(new CallbackListener() {  public void controlEvent(CallbackEvent theEvent) {
      System.out.println("log in!");
      String Username = cp5.get(Textfield.class,"USERNAME").getText();
      String Password = cp5.get(Textfield.class,"PASSWORD").getText();
      System.out.println("Username: " + Username);
      System.out.println("Password: " + Password);
      int res = login(Username,Password);
      if(res == 1){  //se foi feito o login com sucesso
        cp5.hide();
        state = loading_window;
      }
     }
   })
   ;
}


void criarBotaoRegistar(){
        cp5.addButton("CRIAR NAVE")
     .setValue(0)
     .setPosition(145,200) 
     .setSize(200,28)
     .setFont(font)
     .onPress(new CallbackListener() {  public void controlEvent(CallbackEvent theEvent) {
      System.out.println("create account!");
      String Username = cp5.get(Textfield.class,"USERNAME").getText();
      String Password = cp5.get(Textfield.class,"PASSWORD").getText();
      System.out.println("Username: " + Username);
      System.out.println("Password: " + Password);
      createAcc(Username,Password);
      System.out.println("ola");
      Ship nave = new Ship(500,500,20);
      System.out.println(Username);
      registos.put(Username, nave);
      //cp5.hide();
      cp5.get(Textfield.class,"USERNAME").clear();
      cp5.get(Textfield.class,"PASSWORD").clear();
      state = login_window;
     }
   })
   ;
}