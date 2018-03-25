import java.util.LinkedList;

/**
 * Representación de un tablero del juego Reversi/Othello.
 * La representación del tablero es mediante un arreglo bidimensional de enteros
 * que representan: 0 = casilla vacia, 1 = disco del jugador 1, 2 = disco del jugador 2.
 * @author  Rodrigo Colín
 * @version %I%, %G%
 */
class Tablero{
  int dim;
  int[][] mundo;
  boolean[] lineas_validas, jugada;
  LinkedList<Coordenada> casillas_validas = new LinkedList<Coordenada>();
 
  /**
   * Constructor principal de un tablero.
   * @param  dim  anchura, en casillas, del tablero
   * @param  tamano tamaño en pixeles de cada casilla cuadrada del tablero
   */
  Tablero(int dim){
    this.dim = dim;
    mundo = new int[dim][dim]; 
    for(int i = 0; i < this.dim; i++){
      for(int j = 0; j < this.dim; j++){
        mundo[i][j] = 0;
      }
    }
    lineas_validas = new boolean[8];
    jugada = new boolean[8];
    for(int i = 0 ; i < 8 ; i++){
        lineas_validas[i] = false;
    }
    
    // Configuración inicial
    mundo[dim/2][dim/2] = 1;
    mundo[dim/2-1][dim/2] = 2;
    mundo[dim/2][dim/2-1] = 2;
    mundo[dim/2-1][dim/2-1] = 1;
  }

  /**
   * Cuenta la cantidad de discos/fichas de un determinado jugador en el Tablero.
   * @param  jugador identificador del jugador, es decir: 1 = Jugador 1, 2 = Jugador 2
   * @return        cantidad de discos/fichas en el tablero del jugador dado como parámetro 
   */
  int fichas(int jugador){
    int total = 0;
    for(int i = 0; i < dim; i++){
      for(int j = 0; j < dim; j++){
        if(mundo[i][j] == jugador)
          total++;
      }
    }
    return total;
  }

  /**
   * Determina si la casilla seleccionada es válida para colocar un disco/ficha.
   * TODO: Realizar una validación más exhaustiva, por el momento solo revisa si la casilla es vacia
   * @param x posición X en Coordenada del tablero(no en pixeles) donde se valida la casilla
   * @param y posición Y en Coordenada del tablero(no en pixeles) donde se valida la casilla
   */
  boolean isValid(int x, int y){
    if(mundo[y][x] == 3){
      casillas_validas.remove(new Coordenada(y, x));
       return true;
    }else
       return false;
  }

  /**
   * Dibuja una representación gráfica del tablero en la ventana de Processing. 
   */
  void display(){
    //Dibujar tablero.
    int desplaza = width/tablero.dim;
    stroke(255);
    for(int i = 0; i < dim; i++){
      line(desplaza*i, 0, desplaza*i, height);
      line(0, desplaza*i, width, desplaza*i);
    }
    for(int i = 0; i < dim; i++){
      for(int j = 0; j < dim; j++){
        if(mundo[i][j] == 1){
          fill(0);
          noStroke();
          ellipse(j*desplaza + desplaza/2, i*desplaza + desplaza/2, desplaza/2, desplaza/2);
        }else if(mundo[i][j] == 2){
          fill(255);
          noStroke();
          ellipse(j*desplaza + desplaza/2, i*desplaza + desplaza/2, desplaza/2, desplaza/2);
        }else if(mundo[i][j] == 3){
           fill(#123456);
           noStroke();
           ellipse(j*desplaza + desplaza/2, i*desplaza + desplaza/2, desplaza/5, desplaza/5);
        }
      }
    }
  }
  
  /*
    Verifica casilla por casilla si esa casilla es una casilla valida para tiro
    @param jugador el color del jugador de turno
  */
  void calculaValido(int jugador){
    for(int i = 0; i < dim ; i++){
      for(int j = 0; j < dim ; j++){
        if(mundo[i][j] == 0){
          if(jugadaValida(i, j, jugador)){
           mundo[i][j] = 3;
           casillas_validas.addLast(new Coordenada(i, j));
          }
        }
      }
    }
  }
  
  /*
    Función que limpia el tablero de toda las juadas validas para dejar solo el  mundo con 0, 1, 2
  */
  public void limpia(){
    for(Coordenada cor : casillas_validas){
      mundo[cor.getX()][cor.getY()] = 0;  
    }
    casillas_validas.clear();
  }
  
  /*
    Funcion que verifica en una casilla es valida primero verificando adyacencias 
  */
  boolean jugadaValida(int  x, int y, int turno_actual ){
      int turno_contrario =(turno_actual % 2) +1;
      if(x == 0){
        if(y == 0){
            // Caso esquina superior izquierda
            if(mundo[x][y+1] == turno_contrario){
                  lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
            }
            
            if(mundo[x+1][y] == turno_contrario){
               lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);  
            }
            
            if(mundo[x+1][y+1] == turno_contrario){
               lineas_validas[7] = verificaLinea(x, y, 7, turno_contrario, turno_actual); 
            }
            
            
        }else{
           if(y == dim-1){
               // Caso esquina superior derecha
              if(mundo[x][y-1] == turno_contrario){
                 lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
              }
              
              if(mundo[x+1][y] == turno_contrario){
                lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);
              }
              
              if(mundo[x+1][y-1] == turno_contrario){
                  lineas_validas[5] = verificaLinea(x, y, 5, turno_contrario, turno_actual);
              }
           }else{
             // Caso linea superior del tablero sin tomar en cuenta las esquinas
             if(mundo[x][y-1] == turno_contrario){
                 lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
              }
              
              if(mundo[x+1][y-1] == turno_contrario){
                  lineas_validas[5] = verificaLinea(x, y, 5, turno_contrario, turno_actual);
              }
              
              if(mundo[x+1][y] == turno_contrario){
                lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);
              }
              
              if(mundo[x+1][y+1] == turno_contrario){
                 lineas_validas[7] = verificaLinea(x, y, 7, turno_contrario, turno_actual); 
              }
              
              if(mundo[x][y+1] == turno_contrario){
                  lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
              }        
           }
        }
      }else{
         if(x  == dim-1){
            if(y == 0){
              // Caso esquina inferior izquierda
               if(mundo[x][y+1] == turno_contrario){
                  lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
              } 
              
               if(mundo[x-1][y] == turno_contrario){
                  lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
              } 
              
               if(mundo[x-1][y+1] == turno_contrario){ 
                  lineas_validas[2] = verificaLinea(x, y, 2, turno_contrario, turno_actual);  
              } 
            }else{
               if(y == dim-1){
                 // Caso esquina inferior derecha 
                 if(mundo[x][y-1] == turno_contrario){
                   lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
                 }
                
                  if(mundo[x-1][y] == turno_contrario){
                    lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x-1][y-1] == turno_contrario){
                      lineas_validas[0] = verificaLinea(x, y, 0, turno_contrario, turno_actual);  
                  } 
                
               }else{
                  // Caso borde inferior sin tomar en cuenta las esquinas
                 if(mundo[x][y-1] == turno_contrario){
                   lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
                 }
                
                  if(mundo[x-1][y] == turno_contrario){
                    lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x-1][y-1] == turno_contrario){
                      lineas_validas[0] = verificaLinea(x, y, 0, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x][y+1] == turno_contrario){
                      lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
                  }         
                 if(mundo[x-1][y+1] == turno_contrario){
                    lineas_validas[2] = verificaLinea(x, y, 2, turno_contrario, turno_actual);  
                 }
              }
           }
        }else{
            if(y == 0){
                  // Caso borde izquierdo sin tomar en cuenta las esquinas
                  if(mundo[x-1][y] == turno_contrario){
                    lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x][y+1] == turno_contrario){
                      lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
                  }         
                 if(mundo[x-1][y+1] == turno_contrario){ 
                    lineas_validas[2] = verificaLinea(x, y, 2, turno_contrario, turno_actual);  
                 }
                 
                 if(mundo[x+1][y] == turno_contrario){
                    lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);
                  }
              
                if(mundo[x+1][y+1] == turno_contrario){
                   lineas_validas[7] = verificaLinea(x, y, 7, turno_contrario, turno_actual); 
                }
            }else{
              if(y == dim-1){
                  // Caso borde derecho sin tomar en cuenta las esquinas
                 if(mundo[x][y-1] == turno_contrario){
                   lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
                 }
                
                  if(mundo[x-1][y] == turno_contrario){
                    lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x-1][y-1] == turno_contrario){
                      lineas_validas[0] = verificaLinea(x, y, 0, turno_contrario, turno_actual);  
                  }
                  
                  if(mundo[x+1][y-1] == turno_contrario){
                      lineas_validas[5] = verificaLinea(x, y, 5, turno_contrario, turno_actual);
                  }
                  
                  if(mundo[x+1][y] == turno_contrario){
                    lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);
                  }
              }else{
                  // Caso resto del tablero(para este punto ya no estamos en ningun borde)
                  if(mundo[x-1][y-1] == turno_contrario){
                      lineas_validas[0] = verificaLinea(x, y, 0, turno_contrario, turno_actual);  
                  }
                  if(mundo[x-1][y] == turno_contrario){
                    lineas_validas[1] = verificaLinea(x, y, 1, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x-1][y+1] == turno_contrario){
                    lineas_validas[2] = verificaLinea(x, y, 2, turno_contrario, turno_actual);  
                  }
                 
                 if(mundo[x][y-1] == turno_contrario){
                   lineas_validas[3] = verificaLinea(x, y, 3, turno_contrario, turno_actual); 
                 }
                 
                  if(mundo[x][y+1] == turno_contrario){
                      lineas_validas[4] = verificaLinea(x, y, 4, turno_contrario, turno_actual);  
                  } 
                  
                  if(mundo[x+1][y-1] == turno_contrario){
                      lineas_validas[5] = verificaLinea(x, y, 5, turno_contrario, turno_actual);
                  }
                  
                  if(mundo[x+1][y] == turno_contrario){
                    lineas_validas[6] = verificaLinea(x, y, 6, turno_contrario, turno_actual);
                  }
                  
                  if(mundo[x+1][y+1] == turno_contrario){
                     lineas_validas[7] = verificaLinea(x, y, 7, turno_contrario, turno_actual); 
                  }
              }
            }
        }
      }
      boolean resultado = false;
      for(int i  = 0 ; i < 8 ; i++){
          resultado = resultado || lineas_validas[i];
          jugada[i] = lineas_validas[i];
          lineas_validas[i] = false;
          
      }
      return resultado;
    
  }
  
  /*
    Función que imprime el mundo por casillas 
  */
  public void imprimeMundo(){
      for(int i = 0 ; i < dim ; i++){
         for(int j = 0 ; j < dim ; j++){
            print(mundo[i][j] + ", "); 
         }
         println();
      }
  }
  
  /*
    Cambia de color el una vez que se elije la jugada
  */
  public void actualizaMundo(int j, int i, int turno_actual){
      for(int valida = 0 ; valida < 8 ; valida++){
          jugada[valida] = false;
      }
      jugadaValida(i, j, turno_actual);
      int x, y;
      for(int valida = 0 ; valida < 8 ; valida++){
          if(jugada[valida]){

              switch(valida){
                case 0:
                    x= i-1;
                    y = j-1;
                    while(mundo[x][y] != turno_actual){
                      mundo[x][y] = turno_actual;
                      x--;
                      y--;      
                    }
                    break;
                case 1:
                    x = i-1;
                    while(mundo[x][j] != turno_actual){
                       mundo[x][j] = turno_actual;
                       x--;
                    }
                    break;
                case 2:
                    x= i-1;
                    y = j+1;
                    while(mundo[x][y] != turno_actual){
                      mundo[x][y] = turno_actual;
                      x--;
                      y++;      
                    }
                    break;
                case 3:
                    y = j-1;
                    while(mundo[i][y] != turno_actual){
                       mundo[i][y] = turno_actual;
                       y--;
                    }
                    break;
                case 4:
                    y = j+1;
                    while(mundo[i][y] != turno_actual){
                       mundo[i][y] = turno_actual;
                       y++;
                    }
                    break;
                case 5:
                    x= i+1;
                    y = j-1;
                    while(mundo[x][y] != turno_actual){
                      mundo[x][y] = turno_actual;
                      x++;
                      y--;      
                    }
                    break;
                case 6:
                    x = i+1;
                    while(mundo[x][j] != turno_actual){
                       mundo[x][j] = turno_actual;
                       x++;
                    }
                    break;
                case 7:
                    x= i+1;
                    y = j+1;
                    while(mundo[x][y] != turno_actual){
                      mundo[x][y] = turno_actual;
                      x++;
                      y++;      
                    }
                    break;
              }
          }
      }
  }
  
  /*
    Verifica si en la direccion de la casillas se sigue fichas del color contrario terminando en una del color actual las direcciones se ven
    0 1 2 
    3 * 4
    5 6 7
    el * representa donde esta parado 
    
  */
  boolean verificaLinea(int x, int y, int direccion, int turno_contrario, int turno_actual){
    int i = 0;
    int j = 0;
    
    switch(direccion){
        case 0:
          for(i = 2 ; x-i >= 0 ; i++){
            if(y-i >= 0){
              if(mundo[x-i][y-i] != turno_contrario){
                  if(mundo[x-i][y-i] == turno_actual){
                      return true;
                  }else{
                     return false; 
                  }
              }              
            }
          }
          break;
        case 1:
          for(i = 2 ; x-i >= 0 ; i++){
              if(mundo[x-i][y] != turno_contrario){
                if(mundo[x-i][y] == turno_actual){
                    return true;
                }else{
                   return false; 
                }
             }
          }
          break;
        case 2:
          for(i = 2 ; x-i >= 0 ; i++){
            if(y+i < dim){
               if(mundo[x-i][y+i] != turno_contrario){
                  if(mundo[x-i][y+i] == turno_actual){
                      return true;
                  }else{
                     return false; 
                  }
               }
            }       
          }
          break;
        case 3:
          for(j = 2 ; y-j >= 0 ; j++){
             if(mundo[x][y-j] != turno_contrario){
                if(mundo[x][y-j] == turno_actual){
                    return true;
                }else{
                   return false; 
                }
             }
          }
          break;
        case 4:

          for(j  = 2 ; j+y < dim ; j++){
             if(mundo[x][y+j] != turno_contrario){

                 if(mundo[x][y+j] == turno_actual){

                     return true;
                 }else{
                   return false;
                 }
             }
               
          }
          break;
        case 5:
          for(i = 2 ; x+i < dim ; i++){
            if(y-i >= 0){
              if(mundo[x+i][y-i] != turno_contrario){
                  if(mundo[x+i][y-i] == turno_actual){
                    return true;
                  }else{
                     return false; 
                  }
              }
            }
          }
          break; 
        case 6:
          for(i = 2; i+x < dim ; i++){
             if(mundo[x+i][y] != turno_contrario){
                if(mundo[x+i][y] == turno_actual){
                   return true; 
                }else{
                 return false; 
                }
             }
          }
          break;
        case 7:
          for(i = 2 ; i+x < dim; i++){
            if(y+i < dim){
              if(mundo[x+i][y+i] != turno_contrario){
                   if(mundo[x+i][y+i] == turno_actual){
                       return true;
                   }  
                   else{
                     return false; 
                   }
               }  
            }
          }
          break;
        default:
          return false;
    }
    return false;
  }
  
  /*
    Verifica si quedan tiros posibles para jugar 
  */
  public boolean tieneCasillasLibres(int turno){
    int turno_contrario = (turno % 2) +1;
     for(int i = 0 ; i < dim ; i++){
         for(int j = 0 ; j < dim ; j++){
            if(mundo[i][j] == 0 || mundo[i][j] == 3){
              if(jugadaValida(i, j, turno_contrario)){
                casillas_validas.clear();
                return true;
              }  
            }
         }
      }
      return false;
  }

}