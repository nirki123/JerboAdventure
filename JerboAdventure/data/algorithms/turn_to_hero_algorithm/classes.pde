abstract class BaseShape{
  public float rotation = 0;
  abstract protected int getX();
  abstract protected int getY();
  private float speedX = 0;
  private float speedY = 0;
  public int speed = 0;
  public int direction;

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
  protected void rotateIt() {
    pushMatrix();
    translate(getX(), getY());
    rotate(radians(rotation));
    translate(-getX(), -getY());
    this.drawIt();
    popMatrix();
  }
  abstract protected void drawIt();
  public void draw() {
    if (abs(rotation)%360!=0) {
      this.rotateIt();
    } else {
      this.drawIt();
    }
  }
}

class Rect extends BaseShape{
  public int x;
  public int y;
  public int object_width;
  public int object_height;
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
    
    rectMode(CENTER);
    rect(x, y, object_width, object_height);
  }

  protected int getX() {
    return x;
  }

  protected int getY() {
    return y;
  }
  
  private void turn_to_hero(Rect rect) {
    float y_distance_from_hero = this.y - rect.y;
    float x_distance_from_hero = this.x - rect.x;
    float tangents = y_distance_from_hero/x_distance_from_hero;
    float wanted_direction_radians = atan(tangents);
    int wanted_direction_degrees = int (degrees(wanted_direction_radians));
    if (this.x < rect.x) {
      this.direction = wanted_direction_degrees;
    } else {
      this.direction = wanted_direction_degrees + 180;
    }
  }
  
  private void initialize(){
    this.direction -= 90;
    this.object_width = 100;
    this.object_height = 100;
    this.brush = color(0, 0, 0);
  }
  
  private void update_player(){
    this.rotation = this.direction;
    this.draw();
  }
  
  private void update_bot(){
    this.rotation = this.direction;
    this.turn_to_hero(rect);
    this.speed = 1;
    this.draw();
  }
}
