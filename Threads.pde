class Leitor extends Thread{
  
public void run(){
  String str;
  try{
  while((str = in.readLine()) != null){
    l.lock();
    //String str = in.readLine();
          //l.lock();
          try{
          // ter lock para o spaceship
          carregarInfo(str);
          //notifyAll();
          }finally{ l.unlock(); }
        //le info do erlang, funcao que diz tudo que tem o servidor
        //escreve tudo 
        //tem que ser atómica a operação, ou pelo menos o acesso as variáveis tem que ser restrita

  }  
} catch(Exception e){
  e.printStackTrace();
    System.out.println(e.getMessage());
}

}

}


/*class desenha extends Thread{
  
public void run(){
  while(true){
      try{
        
        
        
      }catch(InterruptedException a) break;
  

  }  
}*/