/*********************************************************************************************/
/*********************************************************************************************/
/**************** in this window you can find the functions and the classes ******************/
/*********************************************************************************************/
/*********************************************************************************************/



//an unum to check which charecter is the bot:
enum Bot_type {
  JERBOA, 
  JERBOA_KING;
}

class Bad_gang{
 int max = 5;
 Bot[] members; 
 King king = new King();
 int dead_amount = 0;
 boolean all_dead = false;
 boolean is_king = false;
 boolean auto_gun = false;
 
 void reset(Bot_type typ){
  if(is_king){
    king.bot_initialize(typ);  
  }
  members = new Bot[max];
  for(int counter = 0; counter < max; counter++){
    members[counter] = new Bot();
    members[counter].bot_initialize(typ);
    if(this.is_king){
      members[counter].is_king =true;
    }
  }
 }
 void gun_reset(){
   for(int counter = 0; counter < max; counter++){
    members[counter].gun = new Gun();
    members[counter].gun.initialize();
    members[counter].gun.damage = 7;
    if(auto_gun){
      members[counter].range_attack_delay = 100;
    }
      

  } 
 }
 void play(Hero hero){
  this.dead_amount = 0; 
  if(is_king){
    king.king_AI(hero);  
  }
  else{
    for(int counter = 0; counter < max; counter++){
      //else{
        members[counter].speed = 1;  
        members[counter].bot_AI(hero);  
      //}
      if(members[counter].is_dead){
       this.dead_amount++; 
      }
    }
    if(level == 10){
      if(bad_gang.members[0].is_dead){
        door.open = true;  
      }
    }
    else if(this.dead_amount == members.length){
      this.all_dead =true;
      door.open = true;
    }
  }
 }
}


/**********************************************************/
/**********************************************************/
/******************* class Base_object ********************/
/**********************************************************/
/**********************************************************/

//class that contains base function to use in every object:
abstract class Base_object {
  public float rotation = 0; //the rotation of the image of the object.
  abstract protected int getX(); //function that returns the x of the object.
  abstract protected int getY(); //function that returns the y of the object.
  private float speedX = 0; //variable to the vector of the x.
  private float speedY = 0; //variable to the vector of the y.
  public int speed = 0; //variable to the speed of the object.
  public int direction; //variable to the direction of the object.

  //function that changes the x of the object in accurding to both direction and speed:
  protected int advanceSpeedX() {
    int advanceX = 0;
    if (speed == 0) {
      speedX = 0;
    } else {
      speedX += (speed) * cos(radians(direction));

      advanceX = round(speedX);

      speedX = speedX - advanceX;
    }
    return advanceX;
  }
  //function that changes the y of the object in accurding to both direction and speed:
  protected int advanceSpeedY() {
    int advanceY = 0;
    if (speed == 0) {
      speedY = 0;
    } else {
      speedY += (speed) * sin(radians(direction));

      advanceY = round(speedY);

      speedY = speedY - advanceY;
    }
    return advanceY;
  }

  //function that rotates the image of the object in accurding to rotation:
  protected void rotateIt() {
    pushMatrix();
    translate(getX(), getY());
    rotate(radians(rotation));
    translate(-getX(), -getY());
    this.drawIt();
    popMatrix();
  }

  //function that draws the object:
  abstract protected void drawIt();
  public void draw() {
    this.rotateIt();
  }
}


/**********************************************************/
/**********************************************************/
/************************ class Hero **********************/
/**********************************************************/
/**********************************************************/


//the class of the object of the hero:
class Hero extends Base_object {
  private PImage image;
  private String path;
  private int x;
  private int y;
  private int object_width = -1;
  private int object_height = -1;
  public  int lifePoint = 100;
  private boolean hero_atk = false;


  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  private void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (object_width == -1) {
      object_width = image.width;
    }
    if (object_height == -1) {
      object_height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    imageMode(CENTER);
    image(image, x, y, this.object_width, this.object_height);
  }

  //function that turn to right:
  private void turn_right() {
    this.direction += 15;
  }

  //function that turn to left:
  private void turn_left() {
    this.direction -= 15;
  }

  //function that walks backwards:
  private void walk_backward() {
    this.speed = -4;
  }


  //function that walks forward:
  private void walk_forward() {
    this.speed = 4;
  }

  private void hero_initialize() {
    this.setImage("all_Hero/hero0.png");
    this.x = width/2 - this.object_width/2;
    this.y = height/2 - this.object_height/2;
    this.proportion_size(20);
    this.direction = 270;
    this.lifePoint = 100;
  }
  private void proportion_size(int size) {
    this.object_width = int((width/100 * this.image.width/100 * size)/10);
    this.object_height = int((width/100 * this.image.height/100 * size)/10);
  }


  private void hero_play() {
    this.rotation = this.direction + 90;
    if (this.direction >= 360) {
      this.direction -= 360;
    }
    if (this.direction < 0) {
      this.direction += 360;
    }
    this.draw();
    if(this.lifePoint <= 0){
      die_screen.show();
    }
    if (this.x + this.object_width/2 > width) {
      this.x = width - this.object_width/2;
    } else if (this.x - this.object_width/2 < 0) {
      this.x = 0 + this.object_width/2;
    }

    if (this.y + this.object_width/2 > height) {
      this.y = height - this.object_width/2;
    } else if (this.y - this.object_width/2 < 0) {
      //println(this.x +"UHUH" + door.object_width + door.x);
      if(this.x < door.object_width + door.x*2 && this.x > door.x - door.object_width/2 && door.open){
        door.enter();
        println("ENTER");
      }
      this.y = 0 + this.object_width/2;
    }
    
  }

  public boolean is_point_in_shape(int x1, int y1) {
    return (this.x <= x1 && this.x + this.object_width >= x1 && this.y <= y1 && this.y + this.object_width >= y1);
  }

}


/**********************************************************/
/**********************************************************/
/************************ class Bot ***********************/
/**********************************************************/
/**********************************************************/


class Bot extends Base_object {
  private PImage image;
  private String path;
  private int x;
  private int y;
  private Gun gun = null;
  

  private int off_set_angle = (int)random(-2,2);
  
  private int object_width = -1;
  private int object_height = -1;
  private float melee_attack_damage = 5;


  private int  melee_attack_timer = 0;
  private int  range_attack_timer = 0;
  private int  king_spawn_timer = 0;
  
  private int  range_attack_delay = 2000;
  private int  king_spawn_delay = 2000;
  
  private int  melee_attack_reset = 0;
  private int  range_attack_reset = 0;
  private int  king_spawn_reset = 0;
  
  private float lifePoint = 100;
  private float wanted_direction_radians;
  private int wanted_direction_degrees;
  private float y_distance_from_hero = 0;
  private float x_distance_from_hero = 0;
  private float tangents;
  private boolean is_dead = false;

  private boolean is_king = false;

  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  private void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (object_width == -1) {
      object_width = image.width;
    }
    if (object_height == -1) {
      object_height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    imageMode(CENTER);
    image(image, x, y, this.object_width, this.object_height);
  }
  private void gun_reset(){
    this.gun = new Gun();
    this.gun.initialize();
    this.gun.damage = 7;  
  }
  private void bot_AI(Hero hero) {
    this.melee_attack_timer = millis() - this.melee_attack_reset;
    this.range_attack_timer = millis() - this.range_attack_reset;
    this.rotation = this.direction + 90 + this.off_set_angle;
    if(this.lifePoint > 0){
      //println(abs(dist(hero.x, hero.y, this.x, this)));
      if (abs(dist(hero.x,hero.y,this.x,this.y)) < 10) {
        this.speed = 0;
        if(this.melee_attack_timer > 2000){
          melee_attack(hero);
          this.melee_attack_reset += this.melee_attack_timer;
        }      
      }
      else {
        this.speed = 1;
      }
      if(this.gun != null){
        if(Math.abs(dist(hero.x,hero.y,this.x,this.y)) < 250){
          this.shoot();
          if(this.gun.ammo[this.gun.ammo.length - 1].shot){
            this.gun.reload();  
          }
        }
        this.gun.update_bot(this);
      }
  
      this.turn_to_hero(hero);
      this.draw();
    }
    else{
     this.is_dead = true; 
     this.x = width + 300;
     this.y = height + 300;
    }
  }
  
  
  private void melee_attack(Hero hero) {
    hero.lifePoint -= this.melee_attack_damage;
  }
  private void shoot(){
    if(this.range_attack_timer > this.range_attack_delay){
      this.gun.shoot(); 
      this.range_attack_reset += range_attack_timer;
    }
  }
  public boolean pointInShape(int x1, int y1) {
    double normalizeXPow2 = pow((x1 - x), 2);
    double normalizeYPow2 = pow((y1 - y), 2);
    double radius_xPow2 = pow(this.object_width, 2);
    double radius_yPow2 = pow(this.object_height, 2);
    return ((normalizeXPow2 / radius_xPow2) + (normalizeYPow2 / radius_yPow2)) <= 1.0;
  }
  private void update(boolean is){
    this.bot_AI(hero);  
    
  }
  private void bot_initialize(Bot_type type) {
    this.speed = 0;
    if (type == Bot_type.JERBOA) {
      this.setImage("jerboa.png");
    }
    if (type == Bot_type.JERBOA_KING) {
      this.setImage("jerboa_king.png");
    }
    this.proportion_size(20);
    this.x = (int)random(width);
    this.y = (int)random(height/2,height);
  }

  private void turn_to_hero(Hero hero) {
    this.y_distance_from_hero = this.y - hero.y;
    this.x_distance_from_hero = this.x - hero.x;
    this.tangents = this.y_distance_from_hero/this.x_distance_from_hero;
    this.wanted_direction_radians = atan(tangents);
    this.wanted_direction_degrees = int (degrees(this.wanted_direction_radians));
    if (this.x < hero.x) {
      this.direction = this.wanted_direction_degrees;
    } else {
      this.direction = this.wanted_direction_degrees + 180;
    }
  }
  private void proportion_size(int size) {
    this.object_width = int((width/100 * this.image.width/100 * size)/10);
    this.object_height = int((width/100 * this.image.height/100 * size)/10);
  }
  

}

class King extends Base_object {
  private PImage image;
  private String path;
  private int x;
  private int y;
  private Gun gun = null;
  

  private int off_set_angle = (int)random(-2,2);
  
  private int object_width = -1;
  private int object_height = -1;
  private float melee_attack_damage = 5;


  private int  melee_attack_timer = 0;
  private int  range_attack_timer = 0;
  private int  king_spawn_timer = 0;
  
  private int  range_attack_delay = 2000;
  private int  king_spawn_delay = 4 * 1000;
  
  private int  melee_attack_reset = 0;
  private int  range_attack_reset = 0;
  private int  king_spawn_reset = 0;
  
  private float lifePoint = 200;
  private float wanted_direction_radians;
  private int wanted_direction_degrees;
  private float y_distance_from_hero = 0;
  private float x_distance_from_hero = 0;
  private float tangents;
  private boolean is_dead = false;

  private boolean is_king = false;

  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  private void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (object_width == -1) {
      object_width = image.width;
    }
    if (object_height == -1) {
      object_height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    imageMode(CENTER);
    image(image, x, y, this.object_width, this.object_height);
  }
  
  private void king_AI(Hero hero) {
    this.king_spawn_timer = millis() - this.king_spawn_reset;
    this.rotation = this.direction + 90 + this.off_set_angle;
    if(this.lifePoint > 0){
      //println(abs(dist(hero.x, hero.y, this.x, this)));
  //    println("a: " + this.king_spawn_timer + " b: " + king_spawn_delay);
      if(this.king_spawn_timer > this.king_spawn_delay){
        println("SPAWN");
        bot = new Bot();
        bot.bot_initialize(Bot_type.JERBOA);
        bot.gun_reset();
        king_bots.members =(Bot[]) (append(king_bots.members, bot));
        println(king_bots.members.length);
        king_bots.max++;
        this.king_spawn_reset += this.king_spawn_timer;
      }
      king_bots.play(hero);
      this.turn_to_hero(hero);
      this.draw();
    }
    else{
     this.is_dead = true; 
     this.x = width + 300;
     this.y = height + 300;
    }
  }
  
  
  private void melee_attack(Hero hero) {
    hero.lifePoint -= this.melee_attack_damage;
  }
  private void shoot(){
    if(this.range_attack_timer > this.range_attack_delay){
      this.gun.shoot(); 
      this.range_attack_reset += range_attack_timer;
    }
  }
  public boolean pointInShape(int x1, int y1) {
    double normalizeXPow2 = pow((x1 - x), 2);
    double normalizeYPow2 = pow((y1 - y), 2);
    double radius_xPow2 = pow(this.object_width, 2);
    double radius_yPow2 = pow(this.object_height, 2);
    return ((normalizeXPow2 / radius_xPow2) + (normalizeYPow2 / radius_yPow2)) <= 1.0;
  }
  private void bot_initialize(Bot_type type) {
    this.speed = 0;
    if (type == Bot_type.JERBOA_KING) {
      this.setImage("jerboa_king.png");
    }
    this.proportion_size(20);
    this.x = (int)random(width);
    this.y = (int)random(height/2,height);
  }

  private void turn_to_hero(Hero hero) {
    this.y_distance_from_hero = this.y - hero.y;
    this.x_distance_from_hero = this.x - hero.x;
    this.tangents = this.y_distance_from_hero/this.x_distance_from_hero;
    this.wanted_direction_radians = atan(tangents);
    this.wanted_direction_degrees = int (degrees(this.wanted_direction_radians));
    if (this.x < hero.x) {
      this.direction = this.wanted_direction_degrees;
    } else {
      this.direction = this.wanted_direction_degrees + 180;
    }
  }
  private void proportion_size(int size) {
    this.object_width = int((width/100 * this.image.width/100 * size)/10);
    this.object_height = int((width/100 * this.image.height/100 * size)/10);
  }
  

}


/**********************************************************/
/**********************************************************/
/************************ Bullet **************************/
/**********************************************************/
/**********************************************************/
class Bullet extends Base_object{
  public int x;
  public int y;
  public int bullet_speed = 7;
  public int radius_x;
  public int radius_y;
  public color brush;
  public int alpha = 255;
  public color pen;
  public boolean hit = false;
  public boolean firing = false;
  public int penThickness;
  public boolean shot = false;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    ellipse(x, y, radius_x * 2, radius_y * 2);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  public boolean pointInShape(int x1, int y1) {
    double normalizeXPow2 = pow((x1 - x), 2);
    double normalizeYPow2 = pow((y1 - y), 2);
    double radius_xPow2 = pow(radius_x, 2);
    double radius_yPow2 = pow(radius_y, 2);
    return ((normalizeXPow2 / radius_xPow2) + (normalizeYPow2 / radius_yPow2)) <= 1.0;
  }

  
  private boolean off_screen(){
    return (this.x > width || this.x < 0 || this.y > height || this.y < 0);
  }
  
  private void initialize(){
    this.x = 0;
    this.y = 0;
    this.radius_x = 5;
    this.radius_y = 5;
    this.brush = color(0, 0, 0);
  }
  
  private void update(Gun gun){
    if(!shot){
      this.direction = gun.direction;
      this.x = width+100;
      this.y = height+100;
    }
    else{
     this.speed = bullet_speed; 
    }
    if(hit || off_screen()){
      this.get_out();
    }
    this.draw();
  }
  
  private void get_out(){
     this.speed = 0;
     this.x = width+100;
     this.y = height+100; 
  }
}



/**********************************************************/
/**********************************************************/
/********************** class Point ***********************/
/**********************************************************/
/**********************************************************/
class Point {
  int x;
  int y;
}


/**********************************************************/
/**********************************************************/
/*********************** class Time ***********************/
/**********************************************************/
/**********************************************************/
class Time{
  int time = 0;
  
  public void reset(){
    time = millis();
  }
  
  public int millis(){
    return (millis() - time);
  }
  
  public float seconds(){
    return ((millis() - time)/1000);
  }
}

/**********************************************************/
/**********************************************************/
/****************** class Main_functions ******************/
/**********************************************************/
/**********************************************************/
class Main_functions {
  private void reset(int lvl) {
    life_points_bar_gray.x = width/25;
    life_points_bar_gray.y = height/23;
    life_points_bar_gray.object_width = int(width/3.2);
    life_points_bar_gray.object_height = int(float(height/100) * 5);
    life_points_bar_gray.brush = color(100, 100, 100);
    
    life_points_bar.x = life_points_bar_gray.x;
    life_points_bar.y = height/23;
    life_points_bar.object_width = int(width/3.2);
    life_points_bar.object_height = int(float(height/100) * 5);
    life_points_bar.brush = color(0, 255, 0);
    
    
    door.open = false;
    bg = loadImage("data/background.jpg");
    bg.resize(width, height);
    //player_sword.sword_initialize();
    //bot_sword.sword_initialize();
    hero.hero_initialize();
    gun_hero.initialize();
    door.initialize();
    //player_hand.hand_initialize(hero);
    switch(lvl){
      case 0:
        open_screen.reset();
      case 1:
        bad_gang.max = 1;
        bad_gang.reset(Bot_type.JERBOA);
        break;
      case 2:
        bad_gang.max = 5;
        bad_gang.reset(Bot_type.JERBOA);
        break;
      case 3:
        bad_gang.max = 10;
        bad_gang.reset(Bot_type.JERBOA);
        break;
      case 4: 
        hero.lifePoint = 100;
        bad_gang.max = 1;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.gun_reset();
        break;
      case 5:
        bad_gang.max = 5;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.gun_reset();
        break;
      case 6:
        bad_gang.max = 10;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.gun_reset();
        break;
      case 7:
        bad_gang.max = 1;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.auto_gun = true;
        bad_gang.gun_reset();
        break;
      case 8:
        hero.lifePoint = 100;
        bad_gang.max = 5;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.auto_gun = true;
        bad_gang.gun_reset();
        break;
      case 9:
        bad_gang.max = 10;
        bad_gang.reset(Bot_type.JERBOA);
        bad_gang.auto_gun = true;
        bad_gang.gun_reset();
        break;
      case 10:
        king_bots.max = 1;
        king_bots.reset(Bot_type.JERBOA); //<>//
        if(int(random(0,10)) < 2){
          bad_gang.auto_gun = true;
        }
        king_bots.gun_reset();
        
        bad_gang.max = 1;
        bad_gang.is_king = true;
        bad_gang.reset(Bot_type.JERBOA_KING);
        //bad_gang.gun_reset();
        break;
      case 11:
        die_screen.reset();
      default:
        
        break;
    }
  }

  private void main_loop(int lvl) {
    background(bg);
    if(lvl > 0 && lvl < 11){
      //player_sword.sword_play(hero);
      //bot_sword.sword_play(bad_guy);
      //player_hand.hand_play(hero);
      bad_gang.play(hero);
      gun_hero.update_hero();
      hero.hero_play();
      door.play();
      if(lvl == 10){
        king_bots.play(hero);  
      }
      
      
      life_points_bar.object_width = int((width/3.2)/100 * hero.lifePoint);
      life_points_bar.brush = hero.lifePoint > 50 ? color(5.1 * (100 - hero.lifePoint), 255, 0): color(255, 5.1 * hero.lifePoint, 0);
      life_points_bar_gray.draw();
      life_points_bar.draw();
      
    }
    else if (lvl == 0){
      open_screen.update();  
    }
    else{
      die_screen.update();  
    }
    //////////sword_line_left.place_line(bot_sword);
  }
  private void key_events() {
    if (key == 'd') {
      hero.turn_right();
    }

    if (key == 'a') {
      hero.turn_left();
    }

    if (key == 's') {
      hero.walk_backward();
    }

    if (key == 'w') {
      hero.walk_forward();
    }
    
    if(key == ' '){
      if(!gun_hero.single_shot){
        gun_hero.shoot();
        gun_hero.single_shot = true;
      }
    }
  }
  private void mouse_pressed(){
    if(open_screen.start_button.is_point_in_shape(mouseX,mouseY) && level == 0){
      door.enter();
    }
    if(die_screen.restart_button.is_point_in_shape(mouseX,mouseY) && level == 11){
      level = 1;
      main_functions.reset(level);
    }
  }

  private void key_release() {
    player_hand.object_height = 1;
    hero.speed = 0;
    hero.hero_atk = false;
    gun_hero.single_shot = false;
  }
}


class Door extends Base_object {
  public int x;
  public int y;
  public int object_width;
  public int object_height;
  public int originalWidth = -1;
  public int originalHeight = -1;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;
  boolean open = false;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    rectMode(CENTER);
    rect(x, y, object_width, object_height);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }

  private void initialize() {
    this.object_width = 200;
    this.object_height = 15;
    this.x = width/2;
    this.y = 0 + this.object_height/2;
    this.brush = color(240,10,15);
  }

  private void enter() {
     level++;
     hero.x = width/2;
     hero.y = height/2;
     main_functions.reset(level);

  }
  private void play() {
    if(this.open){
     this.brush = color(10,240,15); 
    }
    this.draw();
  }
}





class Rect extends Base_object {
  public int x;
  public int y;
  public int object_width;
  public int object_height;
  public int originalWidth = -1;
  public int originalHeight = -1;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;

  protected void drawIt() {
    brush = (brush & 0xffffff) | (alpha << 24);
    pen = (pen & 0xffffff) | (alpha << 24);
    fill(brush);
    if (penThickness == 0) {
      noStroke();
    } else {
      strokeWeight(penThickness);
      stroke(pen);
    }

    x += this.advanceSpeedX();
    y += this.advanceSpeedY();
    
    rectMode(CORNER);
    rect(x, y, object_width, object_height);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }
}




class Gun extends Base_object {
  private PImage image;
  private String path;
  private int timer = 0;
  private int timer_reset = 0;
  private int reload_time = 1000;
  private int damage = 15;
  
  private int x;
  private int off_set;
  private int y;
  private int object_width = -1;
  private int object_height = -1;
  public  int ammo_max = 11;
  public boolean hit = false;
  public boolean in_reload = false;
  public boolean hit_calculated = false;
  private boolean single_shot = false;
  Bullet[] ammo = new Bullet[ammo_max];
  

  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  private void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (object_width == -1) {
      object_width = image.width;
    }
    if (object_height == -1) {
      object_height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    imageMode(CENTER);
    image(image, x, y, this.object_width, this.object_height);
  }
  
  public void initialize(){
    this.setImage("data/boat.png");
    this.proportion_size(25);
    for(int counter = 0; counter < ammo_max; counter++){
      ammo[counter] = new Bullet();
      ammo[counter].initialize();
    }
  }
  private void proportion_size(int size) {
    this.object_width = int((width/100 * this.image.width/100 * size)/10);
    this.object_height = int((width/100 * this.image.height/100 * size)/10);
  }
  public void update_hero(){
    this.timer = millis() - this.timer_reset; 
    this.x = hero.x;
    this.y = hero.y;
    this.direction = hero.direction;
    this.rotation = this.direction - 135;
    for(int counter = 0; counter < ammo_max; counter++){
      ammo[counter].update(this);
    }
    for(int counter = 0; counter < bad_gang.max; counter++){
      hit(bad_gang.members[counter]);
    }

    if(level == 10){
      hit(bad_gang.king);  
      for(int counter = 0; counter < king_bots.max; counter++){
        hit(king_bots.members[counter]);
      }
    }
    this.draw();
  }
  
  public void update_bot(Bot owner){
    this.x = owner.x;
    this.y = owner.y;
    this.off_set = (int)random(-10, 10);
    this.direction = owner.direction + this.off_set;;
    this.rotation = this.direction - 135 - this.off_set;
    for(int counter = 0; counter < ammo_max; counter++){
      ammo[counter].update(this);
    }
    hit(hero);
    this.draw();
  }
  public void hit(Bot bot) {
    for(int counter = 0; counter < ammo_max; counter++){
      bullet.x = ammo[counter].x;
      bullet.y = ammo[counter].y;
     // println("bot cor x: " + bot.x + " bot cor y: " + bot.y + " mouse x: " + mouseX + " mouse y: " + mouseY + " bot lp: " + bot.lifePoint + " smjnjwe: " + colider.point_intersection(bullet, bot));
      if(colider.point_intersection(bullet, bot) && bot.lifePoint > 0){
        if(!ammo[counter].hit){
          bot.lifePoint -= this.damage;
          ammo[counter].get_out();
        }
        ammo[counter].hit = true; 
        //println(bot.lifePoint);
      }
      else{
        ammo[counter].hit = false;
      }
    }
  }

  public void hit(King bot) {
    for(int counter = 0; counter < ammo_max; counter++){
      bullet.x = ammo[counter].x;
      bullet.y = ammo[counter].y;
      //println("bot cor x: " + bot.x + " bot cor y: " + bot.y + " mouse x: " + mouseX + " mouse y: " + mouseY + " bot lp: " + bot.lifePoint + " smjnjwe: " + colider.point_intersection(bullet, bot));
      if(colider.point_intersection(bullet, bot) && bot.lifePoint > 0){
        if(!ammo[counter].hit){
          bot.lifePoint -= this.damage;
          ammo[counter].get_out();
        }
        ammo[counter].hit = true; 
        //println(bot.lifePoint);
      }
      else{
        ammo[counter].hit = false;
      }
    }
  }

  public void hit(Hero hero) {
    for(int counter = 0; counter < ammo_max; counter++){
      if(hero.is_point_in_shape(ammo[counter].x,ammo[counter].y) && hero.lifePoint > 0){
        if(!ammo[counter].hit){
          hero.lifePoint -= this.damage;
        }
        ammo[counter].hit = true;
      }
      else{
        ammo[counter].hit = false;
      }  
    }
  }
  public void shoot(){
   if(!this.in_reload){
     for(int counter = 0; counter < ammo_max; counter++){
        if(!ammo[counter].shot){
          ammo[counter].shot = true;
          ammo[counter].x = this.x;
          ammo[counter].y = this.y;
          break;
        }
        else if(counter == ammo_max - 1){
          in_reload = true;
          this.timer_reset += this.timer;  
        }
      }
   }
   else if(this.timer > this.reload_time){
     this.reload();
   }
   else{
     //println(this.timer); 
   }
  }
  public void reload(){
    
    for(int counter = 0; counter < ammo_max; counter++){
      ammo[counter].shot = false;
      ammo[counter].firing = false;
    }
    this.in_reload = false;
  }

}


class Colider{
  public int x;
  public int y;
  public float vertex_1_x;
  public float vertex_1_y;
  public int vertex_2_x;
  public int vertex_2_y;
 
  
  private boolean point_intersection(Point point, Bot bot){
    float cos = cos(radians(bot.direction)); //cosinus to find the vertexes.
    float sin = sin(radians(bot.direction)); //sinus to find the vertexes.
    int adjacent = int(cos * bot.object_width/2); //the adjacent of the triangle to find the vertexes.
    int opposite = int(sin * bot.object_width/2); //the opposite of the triangle to find the vertexes.
    float cos_2 = cos(radians(90 - bot.direction)); //cosinus to find the vertexes. to move the point from the center of the leg to the vertex.
    float sin_2 = sin(radians(90 - bot.direction)); //sinus to find the vertexes. to move the point from the center of the leg to the vertex.
    int adjacent_2 = int(cos_2 * bot.object_height/2); //the adjacent of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    int opposite_2 = int(sin_2 * bot.object_height/2); //the opposite of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    
    
    float x_distance_from_vertex_1; //the distance between the mouse's X to the vertex's X.
    float y_distance_from_vertex_1; //the distance between the mouse's Y to the vertex's Y.
    float tangent; //the tangent of the angle between the mouse and the vertex.
    float wanted_direction_radians; //the angle between the mouse and vertex on radians.
    float wanted_direction_degrees; //the angle between the mouse and vertex on degrees.
    int mouse_vertex_direction; //the final angle between the mouse and vertex on degrees.
    int calculations_direction = bot.direction; //new variable to save the value of the direction so we wouldn't change the direction of the rect.
    
    //calculations with the variables below:
    y_distance_from_vertex_1 = point.y - vertex_1_y;
    x_distance_from_vertex_1 = point.x - vertex_1_x;
    tangent = y_distance_from_vertex_1/x_distance_from_vertex_1;
    wanted_direction_radians = atan(tangent);
    wanted_direction_degrees = int (degrees(wanted_direction_radians));
    if (point.x < vertex_1_x){
      mouse_vertex_direction = int(wanted_direction_degrees + 180);
    } else {
      mouse_vertex_direction = int(wanted_direction_degrees + 360);
    }
    if(mouse_vertex_direction > 360){
      mouse_vertex_direction -= 360;
    }
    vertex_1_x = bot.x - adjacent - adjacent_2;
    vertex_1_y = bot.y - opposite + opposite_2;
    
    //make maximum and minimum to the direction var:
    while(calculations_direction < 0){
      calculations_direction += 360;
    }
    if(calculations_direction > 360){
      calculations_direction %= 360;
    }
    
    
    //second vertex (same idea):
    float x_distance_from_vertex_2;
    float y_distance_from_vertex_2;
    float tangent_2;
    float wanted_direction_radians_2;
    float wanted_direction_degrees_2;
    int mouse_vertex_2_direction;
    int calculations_direction_2 = bot.direction;
    int calculations_direction_2_2;
    y_distance_from_vertex_2 = point.y - vertex_2_y;
    x_distance_from_vertex_2 = point.x - vertex_2_x;
    tangent_2 = y_distance_from_vertex_2/x_distance_from_vertex_2;
    wanted_direction_radians_2 = atan(tangent_2);
    wanted_direction_degrees_2 = int (degrees(wanted_direction_radians_2));
    if (point.x < vertex_2_x) {
      mouse_vertex_2_direction = int(wanted_direction_degrees_2 + 180);
    } else {
      mouse_vertex_2_direction = int(wanted_direction_degrees_2 + 360);
    }
    if(mouse_vertex_2_direction > 360){
      mouse_vertex_2_direction -= 360;
    }
    vertex_2_x = bot.x + adjacent + adjacent_2;
    vertex_2_y = bot.y + opposite - opposite_2;
    
    calculations_direction_2 = bot.direction + 90;
    calculations_direction_2_2 = bot.direction + 180;
    
    while(calculations_direction_2 < 0){
      calculations_direction_2 += 360;
    }
    if(calculations_direction_2 > 360){
      calculations_direction_2 %= 360;
    }
    
    while(calculations_direction_2_2 < 0){
      calculations_direction_2_2 += 360;
    }
    if(calculations_direction_2_2 > 360){
      calculations_direction_2_2 %= 360;
    }
    
    
    //fix the problem that after 360 ther is low numbers so 270 degrees > 10 degrees:
    if(calculations_direction > 0 && calculations_direction <= 90 && mouse_vertex_direction > 180){
      calculations_direction += 360;
    }
    if(calculations_direction_2 > 270 && calculations_direction_2 <= 360){
      if(mouse_vertex_2_direction > 180 && calculations_direction_2_2 < 360){
        calculations_direction_2_2 += 360;
      }
      if(mouse_vertex_2_direction <= 180 && calculations_direction_2 > 0){
        calculations_direction_2 -= 360;
      }
    }
    //println("direction: " + calculations_direction_2 + " second: " + (calculations_direction_2_2) + " vertex2mo: " + mouse_vertex_2_direction + " vertex 1 mo: " + mouse_vertex_direction);
    return(mouse_vertex_direction <= calculations_direction && mouse_vertex_direction > calculations_direction - 90 && mouse_vertex_2_direction > calculations_direction_2 && mouse_vertex_2_direction <= calculations_direction_2_2);
  }
  
  private boolean point_intersection(Point point, King bot){
    float cos = cos(radians(bot.direction)); //cosinus to find the vertexes.
    float sin = sin(radians(bot.direction)); //sinus to find the vertexes.
    int adjacent = int(cos * bot.object_width/2); //the adjacent of the triangle to find the vertexes.
    int opposite = int(sin * bot.object_width/2); //the opposite of the triangle to find the vertexes.
    float cos_2 = cos(radians(90 - bot.direction)); //cosinus to find the vertexes. to move the point from the center of the leg to the vertex.
    float sin_2 = sin(radians(90 - bot.direction)); //sinus to find the vertexes. to move the point from the center of the leg to the vertex.
    int adjacent_2 = int(cos_2 * bot.object_height/2); //the adjacent of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    int opposite_2 = int(sin_2 * bot.object_height/2); //the opposite of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    
    
    float x_distance_from_vertex_1; //the distance between the mouse's X to the vertex's X.
    float y_distance_from_vertex_1; //the distance between the mouse's Y to the vertex's Y.
    float tangent; //the tangent of the angle between the mouse and the vertex.
    float wanted_direction_radians; //the angle between the mouse and vertex on radians.
    float wanted_direction_degrees; //the angle between the mouse and vertex on degrees.
    int mouse_vertex_direction; //the final angle between the mouse and vertex on degrees.
    int calculations_direction = bot.direction; //new variable to save the value of the direction so we wouldn't change the direction of the rect.
    
    //calculations with the variables below:
    y_distance_from_vertex_1 = point.y - vertex_1_y;
    x_distance_from_vertex_1 = point.x - vertex_1_x;
    tangent = y_distance_from_vertex_1/x_distance_from_vertex_1;
    wanted_direction_radians = atan(tangent);
    wanted_direction_degrees = int (degrees(wanted_direction_radians));
    if (point.x < vertex_1_x){
      mouse_vertex_direction = int(wanted_direction_degrees + 180);
    } else {
      mouse_vertex_direction = int(wanted_direction_degrees + 360);
    }
    if(mouse_vertex_direction > 360){
      mouse_vertex_direction -= 360;
    }
    vertex_1_x = bot.x - adjacent - adjacent_2;
    vertex_1_y = bot.y - opposite + opposite_2;
    
    //make maximum and minimum to the direction var:
    while(calculations_direction < 0){
      calculations_direction += 360;
    }
    if(calculations_direction > 360){
      calculations_direction %= 360;
    }
    
    
    //second vertex (same idea):
    float x_distance_from_vertex_2;
    float y_distance_from_vertex_2;
    float tangent_2;
    float wanted_direction_radians_2;
    float wanted_direction_degrees_2;
    int mouse_vertex_2_direction;
    int calculations_direction_2 = bot.direction;
    int calculations_direction_2_2;
    y_distance_from_vertex_2 = point.y - vertex_2_y;
    x_distance_from_vertex_2 = point.x - vertex_2_x;
    tangent_2 = y_distance_from_vertex_2/x_distance_from_vertex_2;
    wanted_direction_radians_2 = atan(tangent_2);
    wanted_direction_degrees_2 = int (degrees(wanted_direction_radians_2));
    if (point.x < vertex_2_x) {
      mouse_vertex_2_direction = int(wanted_direction_degrees_2 + 180);
    } else {
      mouse_vertex_2_direction = int(wanted_direction_degrees_2 + 360);
    }
    if(mouse_vertex_2_direction > 360){
      mouse_vertex_2_direction -= 360;
    }
    vertex_2_x = bot.x + adjacent + adjacent_2;
    vertex_2_y = bot.y + opposite - opposite_2;
    
    calculations_direction_2 = bot.direction + 90;
    calculations_direction_2_2 = bot.direction + 180;
    
    while(calculations_direction_2 < 0){
      calculations_direction_2 += 360;
    }
    if(calculations_direction_2 > 360){
      calculations_direction_2 %= 360;
    }
    
    while(calculations_direction_2_2 < 0){
      calculations_direction_2_2 += 360;
    }
    if(calculations_direction_2_2 > 360){
      calculations_direction_2_2 %= 360;
    }
    
    
    //fix the problem that after 360 ther is low numbers so 270 degrees > 10 degrees:
    if(calculations_direction > 0 && calculations_direction <= 90 && mouse_vertex_direction > 180){
      calculations_direction += 360;
    }
    if(calculations_direction_2 > 270 && calculations_direction_2 <= 360){
      if(mouse_vertex_2_direction > 180 && calculations_direction_2_2 < 360){
        calculations_direction_2_2 += 360;
      }
      if(mouse_vertex_2_direction <= 180 && calculations_direction_2 > 0){
        calculations_direction_2 -= 360;
      }
    }
    //println("direction: " + calculations_direction_2 + " second: " + (calculations_direction_2_2) + " vertex2mo: " + mouse_vertex_2_direction + " vertex 1 mo: " + mouse_vertex_direction);
    return(mouse_vertex_direction <= calculations_direction && mouse_vertex_direction > calculations_direction - 90 && mouse_vertex_2_direction > calculations_direction_2 && mouse_vertex_2_direction <= calculations_direction_2_2);
  }
}

class Image extends Base_object {
  private PImage image;
  private String path;
  private int x;
  private int y;
  private int object_width = -1;
  private int object_height = -1;


  protected int getX() {
    return x;
  }
  protected int getY() {
    return y;
  }
  private void setImage(String path_) {
    path = path_;
    image = loadImage(path);
    if (object_width == -1) {
      object_width = image.width;
    }
    if (object_height == -1) {
      object_height = image.height;
    }
  }
  protected void drawIt() {
    x += this.advanceSpeedX();
    y += this.advanceSpeedY();

    imageMode(CORNER);
    image(image, x, y, this.object_width, this.object_height);
  }
  public boolean is_point_in_shape(int x, int y) {
    return (this.x <= x && this.x + this.object_width >= x && y >= this.y && y <= this.y + this.object_height);
  }
}
