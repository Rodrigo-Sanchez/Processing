public class Bar{
  
  int ancho;
  int alto;
  int x;
  int y;
  color c;
  
  Bar(int ancho, int alto, int x, int y, color c){
    this.ancho = ancho;
    this.alto = alto;
    this.x = x;
    this.y = y;
    this.c = c;
  }

  void dibuja(){
    fill(c);
    ellipse(x, y, ancho, alto);
  }

}