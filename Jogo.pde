import controlP5.*;
import java.lang.Thread;
import java.lang.Runnable;
import java.util.concurrent.locks.*;
import java.util.concurrent.Semaphore;
import java.util.*;
import java.lang.*;
/*import java.lang.Thread;
import java.lang.Runnable;
import java.util.concurrent.locks.*;
import java.util.concurrent.Semaphore;*/

Socket s;
ControlP5 cp5;
ControlP5 cp6;
ControlP5 cp7;
boolean OK = true;
boolean loading = false;
int flag = 0;
PrintWriter out;
BufferedReader in;
//String textValue = "";
//Textfield myTextfield;

private Map<String, Ship> registos;
private Map<Integer, Ball> planetas;
//private Lock l;

final int login_window = 0;
final int loading_window = 1;
final int game_window = 2;
final int gameover_window = 3;
int state = login_window; //mudar para login_window depois

PImage starfield;
PImage spacefield;
PImage gameover;

PFont f;
PFont font;

// Info do jogador que corre este programa
String username;
String password;

// Linha que vai ler a partir do socket.
String line;

Lock l = new ReentrantLock();


Ball[] balls =  { 
  new Ball(100, 100, 20), 
  new Ball(300, 300, 80),
  new Ball(600, 500, 50),
  new Ball(800, 700, 40)
};

//Ball[] balls = new Ball[4];

Ship nave = new Ship(500,500,20);
Leitor t = new Leitor();

void setup() {
  //System.out.println("Ola\n"); -> Só faz 1 vez este comando.
  
  size(1024, 768, P3D);
  noStroke();
  
  starfield = loadImage("starfield.png");
  spacefield = loadImage("spacefield.png");
  //rectMode(CENTER);
  
  
  font = createFont("arial",15);
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  
  registos = new HashMap<String, Ship>();
  planetas = new HashMap<Integer, Ball>();
   
  try{
  s = new Socket("127.0.0.1", 12345);
  out = new PrintWriter(s.getOutputStream());
  in = new BufferedReader(new InputStreamReader(s.getInputStream()));
  }catch(Exception e){
  e.printStackTrace();
  System.exit(0);
  }
  
  //t.start();
  criarBotaoUsername();
  criarBotaoPassword();
  criarBotaoLogin();
  criarBotaoRegistar();
  
  buscarInfo();


   /*cp6.addButton("LOGOUT")
     .setValue(0)
     .setPosition(35,40) 
     .setSize(200,28)
     .setFont(font)
     .onPress(new CallbackListener() {  public void controlEvent(CallbackEvent theEvent) {
      System.out.println("log out!");
      //String Username = cp5.get(Textfield.class,"USERNAME").getText();
      //String Password = cp5.get(Textfield.class,"PASSWORD").getText();
      //System.out.println("Username: " + Username);
      //System.out.println("Password: " + Password);
      //logout(Username,Password);
      cp5.show();
      cp5.get(Textfield.class,"USERNAME").clear();
      cp5.get(Textfield.class,"PASSWORD").clear();
      state = login_window;
     }
   })
   ;*/
   
  f = createFont("Dotum-20.vlw", 20, true);
  smooth();
  //fill(255);
  
}

void draw() {
  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  background(0);
  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  //hint(DISABLE_DEPTH_MASK);
  //image(starfield, 0, 0, width, height);
  //hint(ENABLE_DEPTH_MASK);
  switch(state){
    case login_window:
      Mostrarlogin();
      break;
    case loading_window:
      Mostrarloading();
      break;
    case game_window:
      Mostrargame();
      break;
  }
  
}

    
    
    
    /*int flag = 0;
    try{
        //if(flag == 0){
        //    s = new Socket("127.0.0.1", 12345);
        //    out = new PrintWriter(s.getOutputStream());
        //    in = new BufferedReader(new InputStreamReader(s.getInputStream()));
         //   flag = 1;
      //  }
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
   }*/
  
/*void createAcc(String user, String pass){
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
}*/
      //___________________________________________________________
      
      /*int valido = 1;
      for(Cliente c: registos.keySet())
          if(c.user.equals(user)){ valido = 0; break; }
      
    if(valido == 1){
      Cliente c1 = new Cliente(user, pass);
      Ship s1 = new Ship(0.0, 0.0, 0.0);
      Tuplo t = new Tuplo(s1, 0);
      registos.put(c1,t);
    }*/
    //________________________________________________________________________
   /* try{
        //if(flag == 0){
          //  s = new Socket("127.0.0.1", 12345);
         //   out = new PrintWriter(s.getOutputStream());
         //   in = new BufferedReader(new InputStreamReader(s.getInputStream()));
         //   flag = 1;
      //  }
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder.append("create_account");
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
   }*/
  
    /*void logout(String user, String pass){
    int flag = 0;
    try{
        //if(flag == 0){
         //   s = new Socket("127.0.0.1", 12345);
         //   out = new PrintWriter(s.getOutputStream());
         //   in = new BufferedReader(new InputStreamReader(s.getInputStream()));
          //  flag = 1;
     //   }
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder.append("logout");
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
  }*/
  
  void keyPressed() {
    if(state == game_window){
      StringBuilder stringBuilder = new StringBuilder();
      if ((keyCode == LEFT) /*&& (nave.leftBattery > 0)*/) {
        //nave.leftBoolean = true;
        stringBuilder.append("leftPress");
        stringBuilder.append(" ");
        stringBuilder.append(username);
        stringBuilder.append(" ");
        stringBuilder.append(password);
        String line = stringBuilder.toString();
        out.println(line);
        out.flush();
        
        //para testar o info do erlang
        
          /*StringBuilder stringBuilder2 = new StringBuilder();
          stringBuilder2.append("info");
          stringBuilder2.append(" ");
          stringBuilder2.append(username);
          stringBuilder2.append(" ");
          stringBuilder2.append(password);
          String line2 = stringBuilder2.toString();
          out.println(line2);
          out.flush();*/
        
      }
      
     if ((keyCode == RIGHT) /*&& (nave.rightBattery > 0)*/) {
        stringBuilder.append("rightPress");
        stringBuilder.append(" ");
        stringBuilder.append(username);
        stringBuilder.append(" ");
        stringBuilder.append(password);
        String line = stringBuilder.toString();
        out.println(line);
        out.flush();
      }
      
    if ((keyCode == UP) /*&& (nave.middleBattery > 0)*/) {
        stringBuilder.append("upPress");
        stringBuilder.append(" ");
        stringBuilder.append(username);
        stringBuilder.append(" ");
        stringBuilder.append(password);
        String line = stringBuilder.toString();
        out.println(line);
        out.flush();
    }
  }
}

void keyReleased() {
  if(state == game_window){
  if ((keyCode == LEFT)) {
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder.append("leftReleased");
  stringBuilder.append(" ");
  stringBuilder.append(username);
  stringBuilder.append(" ");
  stringBuilder.append(password);
  String line = stringBuilder.toString();
  out.println(line);
  out.flush();
  }
  
  if ((keyCode == RIGHT)) {
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder.append("rightReleased");
  stringBuilder.append(" ");
  stringBuilder.append(username);
  stringBuilder.append(" ");
  stringBuilder.append(password);
  String line = stringBuilder.toString();
  out.println(line);
  out.flush();
  }
  
  if ((keyCode == UP)) {
  StringBuilder stringBuilder = new StringBuilder();
  stringBuilder.append("upReleased");
  stringBuilder.append(" ");
  stringBuilder.append(username);
  stringBuilder.append(" ");
  stringBuilder.append(password);
  String line = stringBuilder.toString();
  out.println(line);
  out.flush();
  }
  
  }
}

public void carregarInfo(String info){
  
  System.out.println("eco: " + info);
  String[] args = info.split(",");
  String[] args2 = info.split(" ");
  //System.out.println("eco: " + info);
  int bool = 0;
  for(String s: registos.keySet()){
    if(s.equals(args2[3])) bool = 1;
  }
  
  if(bool == 1){
    Ship s = registos.get(args2[3]);
    nave.updateShipp(args);
    s.updateShipp(args);
  }
  
  /*else{
    Ship s = */
  
 //ainda por completar
  
}

public void buscarInfo(){
  
          String usern = "lol";
          String passwd = "xd";
          try{
          StringBuilder stringBuilder2 = new StringBuilder();
          stringBuilder2.append("info");
          stringBuilder2.append(" ");
          stringBuilder2.append(usern);
          stringBuilder2.append(" ");
          stringBuilder2.append(passwd);
          String line2 = stringBuilder2.toString();
          out.println(line2);
          out.flush();
                   }
         catch(Exception e){
      e.printStackTrace();
      System.exit(0);
      }
          
          
          
          
          try{
            System.out.println("fk off");
          String n = in.readLine();
          String[] args = n.split(";");
          for(String s: args) { System.out.println("hmm" + s + " "); carregarTabela(s); }
          //String p = in.readLine();
          }catch(Exception e){
  e.printStackTrace();
  System.exit(0);
}
  
  
}

public void carregarTabela(String s){
  
  String[] args = s.split(" ");
  String[] args2 = args[0].split(",");
  String[] args3 = args[1].split(",");
   
  if(args[0].equals("info")) return;
  
  Ship nave = new Ship(Float.parseFloat(args3[3]),Float.parseFloat(args3[4]),20);
  nave.updateShipp(args3);+
  registos.put(args2[0], nave);
  
  
  
}

/*public void enviar(String modo, String line){
  out.println(line);
  out.flush();
  //System.out.println("echo: " + in.readLine());
  try{
  String n = in.readLine();
  System.out.println("echo: " + n);
  if(modo.equals("keyPress")){
  if(n.equals("37")){
    nave.leftBoolean = true;
  }
  else if(n.equals("39")){
    nave.rightBoolean = true;
  }
  else if(n.equals("38")){
    nave.speedBoolean = true;
  }
  }
  if(modo.equals("keyReleased")){
      if(n.equals("37")){
    nave.leftBoolean = false;
  }
  else if(n.equals("39")){
    nave.rightBoolean = false;
  }
  else if(n.equals("38")){
    nave.speedBoolean = false;
  }
  }
}catch(Exception e){
  e.printStackTrace();
  System.exit(0);
}
}*/