import javafx.util.Pair;
import java.util.ArrayList;
import java.util.Arrays;
import java.lang.Thread;

/**
  * Clase tablero para el proyecto.
  */
class Tablero{
  /* La dimension del tablero, siempre es cuadrado. */
  int dimension;
  /* El tablero visto como una matriz. */
  int [][] mundo;
  
  boolean[] direccion = new boolean[8];

  /**
   * Constructor único para el tablero.
   * @param dimension la dimension del tablero
   */
  Tablero(int dimension){
    this.dimension = dimension;
    mundo = new int[dimension][dimension];

    // Configuracion inicial de fichas del juego.
    mundo[dimension/2][dimension/2] = 1;
    mundo[dimension/2-1][dimension/2] = -1;
    mundo[dimension/2][dimension/2-1] = -1;
    mundo[dimension/2-1][dimension/2-1] = 1;

    // Configuración inicial de las posibles tiradas del primer jugador.
    asignaMovimientosValidos(jugador);
  }
  
  /**
   * Metodo que muestra el tablero actual.
   */
  void display(){
    int desplaza = width/tablero.dimension;
    int desplazaV = height/tablero.dimension;
    stroke(255);
    
    // Dibuja lineas
    for(int i = 0; i < dimension; i++){
      line(desplaza*i, 0, desplaza*i, height);
      line(0, desplaza*i, width, desplaza*i);
    }
    
    //Dibujar fichas.
    for(int i = 0; i < dimension; i++){
      for(int j = 0; j < dimension; j++){
        if(mundo[i][j] == 1) {
          fill(0);
          noStroke();
          ellipse((i*desplaza)+(desplaza/2), (j*desplazaV)+(desplaza/2), desplaza/2, desplaza/2);
        } else if(mundo[i][j] == -1) {
          fill(255);
          noStroke();
          ellipse((i*desplaza)+(desplaza/2), (j*desplazaV)+(desplaza/2), desplaza/2, desplaza/2);
        } else if (mundo[i][j] == 2) { // El número 2 dibuja las posibles jugadas.
          fill(#123456);
          noStroke(); 
          ellipse((i*desplaza)+(desplaza/2), (j*desplazaV)+(desplaza/2), desplaza/4, desplaza/4);
        }
      }// for anidado
    } // for dibujar fichas
  }// metodo display
  
  /**
   * Metodo para imprimir el tablero en la consola.
   */
  void printTablero(){
    println("Tablero actual");
    for(int i = 0; i < dimension; i++){
      for(int j = 0; j < dimension; j++){
        System.out.printf("| %4d", mundo[j][i]);
      } // for j
      println();
    } // for i
  }
  
  /**
   * Metodo para contar las fichas
   */
  void printFichas(){
    int fichasNegras = 0;
    int fichasBlancas = 0;
    for(int i = 0; i < dimension; i++){
      for(int j = 0; j < dimension; j++){
        if(mundo[i][j] == 1)
          fichasNegras++;
        if(mundo[i][j] == -1)
          fichasBlancas++;
      }
    }
    println("Fichas negras: " + fichasNegras);
    println("Fichas blancas: " + fichasBlancas + "\n");
  }
  
  /**
   * Metodo para hacer la verificacion en busca de casillas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   */
  void verificacion(int x, int y, int ficha){
    // Lista para almacenar las casillas adquiridas en cada verificacion
    ArrayList <Pair<Integer, Integer>> listFichas = new ArrayList <Pair<Integer, Integer>>();
        
    // Llama a todas las verificaciones, 8 en total
    verificacionUp(x, y, ficha, listFichas);
    // Limpiamos la lista para utilizarla tras cada verificacion
    listFichas.clear();
    verificacionDown(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionLeft(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionRight(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionDiagUpLeft(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionDiagDownLeft(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionDiagDownRight(x, y, ficha, listFichas);
    listFichas.clear();
    verificacionDiagUpRight(x, y, ficha, listFichas);
    listFichas.clear();
  }
  
  /**
   * Verificacion de arriba hacia abajo en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionUp(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x][y-1] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x][y-1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x, y-1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionUp(x, y-1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas hacia arriba
    }
  }
  
  /**
   * Verificacion de abajo hacia arriba en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionDown(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer        
      if(mundo[x][y+1] == 0)
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      else if(mundo[x][y+1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x, y+1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionDown(x, y+1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas hacia abajo
    }
  }
  
  /**
   * Verificacion de izquierda a derecha en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionLeft(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer        
      if(mundo[x-1][y] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x-1][y] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x-1, y));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionLeft(x-1, y, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas hacia la derecha
    }
  }
  
  /**
   * Verificacion de derecha a izquierda en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionRight(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x+1][y] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x+1][y] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x+1, y));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionRight(x+1, y, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas hacia la izquierda
    }
  }
  
  /**
   * Verificacion de abajo hacia arriba diagonalmente hacia la izquierda en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionDiagUpLeft(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x+1][y+1] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x+1][y+1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x+1, y+1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionDiagUpLeft(x+1, y+1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // // No es posible verificar mas arriba diagonal izquierda
    }
  }
  
  /**
   * Verificacion de arriba hacia abajo diagonalmente hacia la izquierda en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionDiagDownLeft(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x-1][y-1] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x-1][y-1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x-1, y-1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionDiagDownLeft(x-1, y-1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas abajo diagonal izquierda
    }
  }
  
  /**
   * Verificacion de arriba hacia abajo diagonalmente hacia la derecha en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionDiagDownRight(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x+1][y-1] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x+1][y-1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x+1, y-1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionDiagDownRight(x+1, y-1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas abajo diagonal derecha
    }
  }
  
  /**
   * Verificacion de abajo hacia arriba diagonalmente hacia la derecha en busca de mas fichas adquiridas por el jugador
   * @param x coordenada x de la casilla introducida por el jugador
   * @param y coordenada y de la casilla introducida por el jugador
   * @param ficha la ficha del jugador (blanca o negra)
   * @param listFichas la lista donde se agregan las fichas a cambiar
   */
  void verificacionDiagUpRight(int x, int y, int ficha, ArrayList <Pair<Integer, Integer>> listFichas){
    try{
      // Casilla vacia, nada que hacer
      if(mundo[x-1][y+1] == 0){
        return;
      // Encuentra casilla del mismo color, pinta todas las encontradas
      }else if(mundo[x-1][y+1] == ficha){
        pintarSecuencia(listFichas, ficha);
        return;
      }else{
        // Agrega la casilla contigua a la lista
        listFichas.add(new Pair<Integer, Integer>(x-1, y+1));
        // Llama la funcion recursiva con el siguiente a verificar en la misma direccion
        verificacionDiagUpRight(x-1, y+1, ficha, listFichas);
      }
    }catch(ArrayIndexOutOfBoundsException e){
      // No es posible verificar mas arriba diagonal derecha
    }
  }
  
  /**
   * Metodo que pinta una secuencia de fichas
   * @param list la lista de las coordenadas a pintar
   * @param ficha el color a pintar
   */
  void pintarSecuencia(ArrayList <Pair<Integer, Integer>> list, int ficha){
    try{
      for(Pair<Integer, Integer> tupla : list){
        // TODO Seria bonito que esto lo haga esperando cada segundo
        mundo[tupla.getKey()][tupla.getValue()] = ficha;
      }
    }catch(Exception e){}
  }
  
  /**
   * Metodo auxiliar para imprimir una lista de tuplas
   * Para pruebas
   */
  void printList(ArrayList <Pair<Integer, Integer>> list){
    for(Pair<Integer, Integer> tupla : list)
      println("X: " + tupla.getKey() + "Y: " + tupla.getValue());
  }  
  
  ////////////////////////////////RODD//////////////////////////////////
  
  /**
   * Recorre el tablero y elimina los movimientos válidos en el turno anterior y
   * asigna los nuevos movimientos válidos del jugador pasado como parámetro.
   * @param 
   */
  void asignaMovimientosValidos(int jugador){
    for(int x = 0; x < dimension; x++)
      for(int y = 0; y < dimension; y++){
        if(mundo[x][y] == 2) //Si una casilla era válida en turno anterior, deja de serlo.
          mundo[x][y] = 0;
        if(mundo[x][y] == 0 && movimientosValidos(x, y, jugador)) //Si una casilla está vacía y cumple con los requisitos para ser movimiento válido, se asigna como tal.
         mundo[x][y] = 2;
      }
  }

  /**
   * Funcion que verifica en una casilla es valida primero verificando adyacencias 
   */
  boolean movimientosValidos(int  x, int y, int jugador){
    int oponente = jugador * -1;
    if(x == 0){
      if(y == 0){
        // Caso esquina superior izquierda
        if(mundo[x][y+1] == oponente)
          direccion[4] = verifica(x, y, 4, jugador, oponente);
        if(mundo[x+1][y] == oponente)
          direccion[6] = verifica(x, y, 6, jugador, oponente);  
        if(mundo[x+1][y+1] == oponente)
          direccion[7] = verifica(x, y, 7, jugador, oponente);
      }else{
        if(y == dimension-1){
        // Caso esquina superior derecha
        if(mundo[x][y-1] == oponente)
          direccion[3] = verifica(x, y, 3, jugador, oponente); 
        if(mundo[x+1][y-1] == oponente)
          direccion[5] = verifica(x, y, 5, jugador, oponente);
        if(mundo[x+1][y] == oponente)
          direccion[6] = verifica(x, y, 6, jugador, oponente);
      }else{
        // Caso linea superior del tablero sin tomar en cuenta las esquinas
        if(mundo[x][y-1] == oponente)
          direccion[3] = verifica(x, y, 3, jugador, oponente); 
        if(mundo[x][y+1] == oponente)
          direccion[4] = verifica(x, y, 4, jugador, oponente);  
        if(mundo[x+1][y-1] == oponente)
          direccion[5] = verifica(x, y, 5, jugador, oponente);
        if(mundo[x+1][y] == oponente)
          direccion[6] = verifica(x, y, 6, jugador, oponente);
        if(mundo[x+1][y+1] == oponente)
          direccion[7] = verifica(x, y, 7, jugador, oponente);
      }
    }
    }else{
      if(x == dimension-1){
        if(y == 0){
          // Caso esquina inferior izquierda
          if(mundo[x-1][y] == oponente)
            direccion[1] = verifica(x, y, 1, jugador, oponente);  
          if(mundo[x-1][y+1] == oponente) 
            direccion[2] = verifica(x, y, 2, jugador, oponente);  
          if(mundo[x][y+1] == oponente)
            direccion[4] = verifica(x, y, 4, jugador, oponente);  
        }else{
          if(y == dimension-1){
          // Caso esquina inferior derecha 
          if(mundo[x][y-1] == oponente)
            direccion[3] = verifica(x, y, 3, jugador, oponente); 
          if(mundo[x-1][y] == oponente)
            direccion[1] = verifica(x, y, 1, jugador, oponente);  
          if(mundo[x-1][y-1] == oponente)
            direccion[0] = verifica(x, y, 0, jugador, oponente);  
        }else{
          // Caso borde inferior sin tomar en cuenta las esquinas
          if(mundo[x][y-1] == oponente)
            direccion[3] = verifica(x, y, 3, jugador, oponente); 
          if(mundo[x-1][y] == oponente)
            direccion[1] = verifica(x, y, 1, jugador, oponente);  
          if(mundo[x-1][y-1] == oponente)
            direccion[0] = verifica(x, y, 0, jugador, oponente);  
          if(mundo[x][y+1] == oponente)
            direccion[4] = verifica(x, y, 4, jugador, oponente);  
          if(mundo[x-1][y+1] == oponente)
            direccion[2] = verifica(x, y, 2, jugador, oponente);
        }
        }
      }else{
        if(y == 0){
          // Caso borde izquierdo sin tomar en cuenta las esquinas
          if(mundo[x-1][y] == oponente)
            direccion[1] = verifica(x, y, 1, jugador, oponente);  
          if(mundo[x-1][y+1] == oponente) 
            direccion[2] = verifica(x, y, 2, jugador, oponente);  
          if(mundo[x][y+1] == oponente)
            direccion[4] = verifica(x, y, 4, jugador, oponente);  
          if(mundo[x+1][y] == oponente)
            direccion[6] = verifica(x, y, 6, jugador, oponente);
          if(mundo[x+1][y+1] == oponente)
            direccion[7] = verifica(x, y, 7, jugador, oponente); 
          }else{
            if(y == dimension-1){
            // Caso borde derecho sin tomar en cuenta las esquinas
            if(mundo[x][y-1] == oponente)
            direccion[3] = verifica(x, y, 3, jugador, oponente); 
          if(mundo[x-1][y] == oponente)
            direccion[1] = verifica(x, y, 1, jugador, oponente);  
          if(mundo[x-1][y-1] == oponente)
            direccion[0] = verifica(x, y, 0, jugador, oponente);  
          if(mundo[x+1][y-1] == oponente)
            direccion[5] = verifica(x, y, 5, jugador, oponente);
          if(mundo[x+1][y] == oponente)
            direccion[6] = verifica(x, y, 6, jugador, oponente);
          }else{
            // Caso resto del tablero(para este punto ya no estamos en ningun borde)
            if(mundo[x-1][y-1] == oponente)
              direccion[0] = verifica(x, y, 0, jugador, oponente);  
            if(mundo[x-1][y] == oponente)
              direccion[1] = verifica(x, y, 1, jugador, oponente);  
            if(mundo[x-1][y+1] == oponente)
              direccion[2] = verifica(x, y, 2, jugador, oponente);  
            if(mundo[x][y-1] == oponente)
              direccion[3] = verifica(x, y, 3, jugador, oponente); 
            if(mundo[x][y+1] == oponente)
              direccion[4] = verifica(x, y, 4, jugador, oponente);  
            if(mundo[x+1][y-1] == oponente)
              direccion[5] = verifica(x, y, 5, jugador, oponente);
            if(mundo[x+1][y] == oponente)
              direccion[6] = verifica(x, y, 6, jugador, oponente);
            if(mundo[x+1][y+1] == oponente)
             direccion[7] = verifica(x, y, 7, jugador, oponente);
          }
        }
      }
    }

    boolean resultado = false;
    for(int i  = 0; i < 8; i++){
      resultado = resultado || direccion[i];
      direccion[i] = false;
    }
    return resultado;
  }

  /*
    Verifica si en la direccion de la casillas se sigue fichas del color contrario terminando en una del color actual las direcciones se ven
    0 1 2 
    3 * 4
    5 6 7
    el * representa donde esta parado
  */
  boolean verifica(int x, int y, int direccion, int jugador, int oponente){
    int i = 0, j = 0;

    switch(direccion){
      case 0:
        for(i = 2; x-i >= 0; i++)
          if(y-i >= 0 && mundo[x-i][y-i] != oponente)
            return mundo[x-i][y-i] == jugador ? true : false;
        break;
      case 1:
        for(i = 2; x-i >= 0; i++)
          if(mundo[x-i][y] != oponente)
            return mundo[x-i][y] == jugador ? true : false;
        break;
      case 2:
        for(i = 2; x-i >= 0; i++)
          if(y+i < dimension && mundo[x-i][y+i] != oponente)
            return mundo[x-i][y+i] == jugador ? true : false;
        break;
      case 3:
        for(j = 2; y-j >= 0; j++)
          if(mundo[x][y-j] != oponente)
            return (mundo[x][y-j] == jugador) ? true : false;
        break;
      case 4:
        for(j  = 2; j+y < dimension; j++)
          if(mundo[x][y+j] != oponente)
            return (mundo[x][y+j] == jugador) ? true : false;
        break;
      case 5:
        for(i = 2; x+i < dimension; i++)
          if(y-i >= 0 && mundo[x+i][y-i] != oponente)
            return mundo[x+i][y-i] == jugador ? true : false;
        break; 
      case 6:
        for(i = 2; i+x < dimension; i++)
          if(mundo[x+i][y] != oponente)
            return mundo[x+i][y] == jugador ? true : false;
        break;
      case 7:
        for(i = 2; i+x < dimension; i++)
          if(y+i < dimension && mundo[x+i][y+i] != oponente)
            return mundo[x+i][y+i] == jugador ? true : false;
          break;
      default:
        return false;
    }
    return false;
  }

  /**
   * Cuenta las fichas de un jugador.
   * @param jugador el entero que representa al jugador.
   */
  public int fichas(int jugador){
    int total = 0;
    for(int i = 0; i < dimension; i++)
      for(int j = 0; j < dimension; j++)
        if(mundo[i][j] == jugador)
          total++;
    return total;
  }

}