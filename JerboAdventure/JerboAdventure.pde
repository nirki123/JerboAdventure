/*********************************************************************************************/
/*********************************************************************************************/
/********************** in this window you can find the main activity ************************/
/*********************************************************************************************/
/*********************************************************************************************/





void setup(){
  size(800,600);
  main_functions.reset(level);
}

void draw(){
  main_functions.main_loop(level);
}


void keyPressed(){
  main_functions.key_events();
}
void mousePressed(){
  main_functions.mouse_pressed();
}
void keyReleased(){
  main_functions.key_release();
}
