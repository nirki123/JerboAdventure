class Open_screen{
  public boolean is_active = true;
  public Image start_button = new Image();
  public Image title = new Image();
  public Image jeri = new Image();
  void reset(){
    start_button.setImage("data/start_not.png");
    title.setImage("data/title.png");
    jeri.setImage("data/jerboa_king.png");
    title.object_width /= 1.7;
    title.object_height /= 1.7;
    jeri.object_width /= 1.7;
    jeri.object_height /= 1.7;
    start_button.x = width/2 - start_button.object_width/2;
    start_button.y = height/2  + height/6;
    
    title.x = width/2 - title.object_width/2;
    title.y = title.object_height/2;    
    
    jeri.x = width/2 - jeri.object_width/2;
    jeri.y = height/2 - jeri.object_height/2 - 50;
  }
  void update(){
    if(start_button.is_point_in_shape(mouseX,mouseY)){
      start_button.setImage("data/start_yes.png");  
    }
    else{
      start_button.setImage("data/start_not.png");        
    }
    jeri.draw();
    title.draw();
    start_button.draw();
  }
}
class Die_screen{
  public boolean is_active = true;
  public Image restart_button = new Image();
  public Image game_over = new Image();
  void reset(){
    restart_button.setImage("data/restart_not.png");
    game_over.setImage("data/game_over.png");
    imageMode(CORNER);
    restart_button.x = width/2 - restart_button.object_width/2;
    restart_button.y = height/2  + height/6;
    
    game_over.x = width/2 - game_over.object_width/2;
    game_over.y = game_over.object_height/2;
  }
  void show(){
     level = 11;
     main_functions.reset(level);
  }
  void update(){
    if(restart_button.is_point_in_shape(mouseX,mouseY)){
      restart_button.setImage("data/restart_yes.png");  
    }
    else{
      restart_button.setImage("data/restart_not.png");        
    }
    game_over.draw();
    restart_button.draw();
  }
}
