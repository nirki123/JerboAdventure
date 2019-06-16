class Point{
  int x;
  int y;
}

class My_rect extends BaseShape{
  public int x;
  public int y;
  public float vertex_1_x;
  public float vertex_1_y;
  public int vertex_2_x;
  public int vertex_2_y;
  public int object_width;
  public int object_height;
  public int originalWidth = -1;
  public int originalHeight = -1;
  public color brush;
  public int alpha = 255;
  public color pen;
  public int penThickness;
  

  protected void drawIt() {
    rotation = direction;
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
  
  private void initialize(){
    this.x = width/2;
    this.y = height/2;
    this.object_width = int(random(1, width/2));
    this.object_height = int(random(1, height/2));
    this.brush = color(0, 0, 0);
    this.direction = int(random(0, 180));
  }
  
  private boolean point_intersection(Point point){ //<>//
    float cos = cos(radians(this.direction)); //cosinus to find the vertexes.
    float sin = sin(radians(this.direction)); //sinus to find the vertexes.
    int adjacent = int(cos * this.object_width/2); //the adjacent of the triangle to find the vertexes.
    int opposite = int(sin * this.object_width/2); //the opposite of the triangle to find the vertexes.
    float cos_2 = cos(radians(90 - this.direction)); //cosinus to find the vertexes. to move the point from the center of the leg to the vertex.
    float sin_2 = sin(radians(90 - this.direction)); //sinus to find the vertexes. to move the point from the center of the leg to the vertex.
    int adjacent_2 = int(cos_2 * this.object_height/2); //the adjacent of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    int opposite_2 = int(sin_2 * this.object_height/2); //the opposite of the triangle to find the vertexes. to move the point from the center of the leg to the vertex.
    
    
    float x_distance_from_vertex_1; //the distance between the mouse's X to the vertex's X.
    float y_distance_from_vertex_1; //the distance between the mouse's Y to the vertex's Y.
    float tangent; //the tangent of the angle between the mouse and the vertex.
    float wanted_direction_radians; //the angle between the mouse and vertex on radians.
    float wanted_direction_degrees; //the angle between the mouse and vertex on degrees.
    int mouse_vertex_direction; //the final angle between the mouse and vertex on degrees.
    int calculations_direction = this.direction; //new variable to save the value of the direction so we wouldn't change the direction of the rect.
    
    //calculations with the variables below:
    y_distance_from_vertex_1 = point.y - vertex_1_y;
    x_distance_from_vertex_1 = point.x - vertex_1_x;
    tangent = y_distance_from_vertex_1/x_distance_from_vertex_1;
    wanted_direction_radians = atan(tangent);
    wanted_direction_degrees = int (degrees(wanted_direction_radians));
    if (mouseX < vertex_1_x){
      mouse_vertex_direction = int(wanted_direction_degrees + 180);
    } else {
      mouse_vertex_direction = int(wanted_direction_degrees + 360);
    }
    if(mouse_vertex_direction > 360){
      mouse_vertex_direction -= 360;
    }
    vertex_1_x = width/2 - adjacent - adjacent_2;
    vertex_1_y = height/2 - opposite + opposite_2;
    
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
    int calculations_direction_2 = this.direction;
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
    vertex_2_x = width/2 + adjacent + adjacent_2;
    vertex_2_y = height/2 + opposite - opposite_2;
    
    calculations_direction_2 = this.direction + 90;
    calculations_direction_2_2 = this.direction + 180;
    
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
    println("direction: " + calculations_direction_2 + " second: " + (calculations_direction_2_2) + " vertex2mo: " + mouse_vertex_2_direction + " vertex 1 mo: " + mouse_vertex_direction);
    return(mouse_vertex_direction <= calculations_direction && mouse_vertex_direction > calculations_direction - 90 && mouse_vertex_2_direction > calculations_direction_2 && mouse_vertex_2_direction <= calculations_direction_2_2); //<>//
  }
}


Point point = new Point();
My_rect rect = new My_rect();

Line line = new Line();
Line line_2 = new Line();

void setup(){
  size(800, 600);
  rect.initialize();
  point.x = 0;
  point.y = 0;
  
  line.x1 = int(rect.vertex_1_x);
  line.y1 = int(rect.vertex_1_y);
  line.x2 = mouseX;
  line.y2 = mouseY;
  line.penThickness = 4;
  line.pen = color(128, 128, 128);
  
  line_2.x1 = rect.vertex_2_x;
  line_2.y1 = rect.vertex_2_y;
  line_2.x2 = mouseX;
  line_2.y2 = mouseY;
  line_2.penThickness = 4;
  line_2.pen = color(128, 128, 128);
}

void draw(){
  if(rect.point_intersection(point)){
    background(0, 0, 0);
    rect.brush = color(255, 255, 255);
  }
  else{
    background(255, 255, 255);
    rect.brush = color(0, 0, 0);
  }
  point.x = mouseX;
  point.y = mouseY;
  
  rect.draw();
  
  line.x1 = int(rect.vertex_1_x);
  line.y1 = int(rect.vertex_1_y);
  line.x2 = mouseX;
  line.y2 = mouseY;
  line.draw();
  
  line_2.x1 = rect.vertex_2_x;
  line_2.y1 = rect.vertex_2_y;
  line_2.x2 = mouseX;
  line_2.y2 = mouseY;
  line_2.draw();
}

void keyPressed(){
  if(keyCode == RIGHT){
    rect.direction += 10;
  }
  if(keyCode == LEFT){
    rect.direction -= 10;
  }
}
