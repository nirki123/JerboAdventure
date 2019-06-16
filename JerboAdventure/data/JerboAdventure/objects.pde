/*********************************************************************************************/
/*********************************************************************************************/
/************************** in this window you can find the objects **************************/
/*********************************************************************************************/
/*********************************************************************************************/




PImage bg;
int level = 0;
Time  male_attack_timer = new Time();

Bot bot = new Bot();

Open_screen open_screen = new Open_screen();
Die_screen die_screen = new Die_screen();

//make the hero object:
Hero hero = new Hero();

Rect player_hand = new Rect();

Door door = new Door();


//make the bot object:
Bad_gang bad_gang = new Bad_gang();

Bad_gang king_bots = new Bad_gang();

Gun gun_hero = new Gun();


Colider colider = new Colider();

Point bullet = new Point();

//make an object to use te main functions of the game:
Main_functions main_functions = new Main_functions();

Rect life_points_bar = new Rect();

Rect life_points_bar_gray = new Rect();
