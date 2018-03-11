//ellipse(20,20,80,80);
//int x;

Bar punto;

void setup(){
    if(mousePressed)
      punto = new Bar(10,10,mouseX,mouseY,color(120,10,89));
      punto.dibuja();
}
void draw(){
}

/*void setup(){
  w,x,y,z=0;
  background(0,0,0);
  size(500,500);
}/

/*void draw() {
  background(0,0,0);
  ellipse(w, x, y, z);
  ellipse(x, 50, 80, 80);
   x++;
  if(x>=width)
    x=0;
}*/

/*void draw() {
  if (mousePressed && (mouseButton == LEFT)) {
    fill(255);
    ellipse(mouseX, mouseY, 80, 80);
    println("Click izquierdo con X: " + mouseX + ", Y: " + mouseY);
  } else if (mousePressed && (mouseButton == RIGHT)){
    fill(127);
    ellipse(mouseX, mouseY, 80, 80);
    println("Click derecho con X: " + mouseX + ", Y: " + mouseY);
  }
}*/