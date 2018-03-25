Tablero tablero; 
boolean turno = true;
int x, y, dimension = 8, jugador = 1, detener = 0;

void setup(){
  size(600, 600);
  background(#23A231);
  println("Va el jugador 1");
  tablero = new Tablero(dimension);
  tablero.calculaValido(jugador);
}

void draw(){
  if(tablero.casillas_validas.isEmpty()){
    if(tablero.tieneCasillasLibres(jugador)){
      println("El jugador " + jugador + " no pudo tirar.");
      turno = !turno;
      jugador = turno ? 1 : 2;
      println("Tira el siguiente jugador: " + jugador);
    }else{
      if(tablero.fichas(1) == tablero.fichas(2))
          println("Es un empate.");
      if(tablero.fichas(1) > tablero.fichas(2))
          println("Ganó el jugador 1.");
      if(tablero.fichas(1) < tablero.fichas(2))
        println("Ganó el jugador 2.");
      stop();
    }
  }
  tablero.display();
}

void mouseClicked(){
    x = mouseX/(width/tablero.dim);
    y = mouseY/(height/tablero.dim);

    //Colocar un disco/ficha en el tablero:
    if(tablero.isValid(x, y)){
      tablero.mundo[y][x] = jugador;
      tablero.actualizaMundo(x, y, jugador);
      tablero.limpia();
      turno = !turno;
      jugador = turno ? 1 : 2;

      //La variable para detener se reinicia.
      detener = 0;
      tablero.calculaValido(jugador);
      tablero.imprimeMundo();
      println("Va el jugador: " + jugador);
      println("El jugador negro tiene:  " + tablero.fichas(1));
      println("El jugador blanco tiene: " + tablero.fichas(2));
    }
}