/* El tablero del juego */
Tablero tablero;
/* La dimension fija del tablero. */
int dimension = 8, jugador = 1;
boolean turno = true;

/**
 * Metodo con la configuracion inicial del tablero. 
 */
void setup() {
  // Tamaño de la ventana
  size(500, 500);
  background(#23A231);
  tablero = new Tablero(dimension);
}

/**
 * Metodo que se dibuja en cada frame.
 */
void draw() {
  tablero.display();
}

/**
 * Método que se ejecuta cuando se da click en una casilla
 * del tablero. */
void mouseClicked(){
  int x = mouseX / (width / tablero.dimension);
  int y = mouseY / (height / tablero.dimension);
  int ficha;

  if(tablero.mundo[x][y] == 2){
    // TODO IMPLEMENTAR SUGERENCIAS
    tablero.mundo[x][y] = jugador;
    ficha = tablero.mundo[x][y];
    tablero.verificacion(x, y, ficha);

    turno = !turno;
    jugador = turno ? 1 : -1;
  
    tablero.limpia();
    tablero.movimientosValidos(jugador);

    tablero.printTablero();
    tablero.printFichas();
  }
  
}