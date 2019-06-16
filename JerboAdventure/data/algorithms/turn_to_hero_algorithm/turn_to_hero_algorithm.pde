void setup(){
  size(800, 600);
  rect.initialize();
  rect_2.initialize();
  rect.x = width/2;
  rect.y = height/2;
}

void draw(){
  background(255, 255, 255);
  rect.update_player();
  rect_2.update_bot();
}

void keyPressed(){
  if(keyCode == UP){
    rect.speed = 3;
  }
  else if(keyCode == DOWN){
    rect.speed = -3;
  }
  else if(keyCode == RIGHT){
    rect.direction += 10;
  }
  else if(keyCode == LEFT){
    rect.direction -= 10;
  }
}

void keyReleased(){
  rect.speed = 0;
}
