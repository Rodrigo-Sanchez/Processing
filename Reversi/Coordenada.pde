/**
 * Clase para guardar coordenadas de las casillas.
 */
public class Coordenada{
   int x, y;
   
  /**
   * Constructor con parámetros
   * @param x especifica la coordenada en el eje horizontal.
   * @param y especifica la coordenada en el eje vertical.
   */
   public Coordenada(int x, int y){
      this.x = x;
      this.y = y;
   }
   
   /**
    * @return Valor de la coordenada x.
    */
   public int getX(){
     return x;
   }

   /**
    * @return Valor de la coordenada y.
    */
   public int getY(){
     return y; 
   }
   
   /**
    * Método que sobreescribe al de la clase Object.
    * @param obj El objeto a comparar.
    * @return El objeto es igual si sus coordenadas son las mismas.
    */
   @Override
   public boolean equals(Object obj){
     Coordenada coordenada =(Coordenada)obj;
     return this.getX() == coordenada.getX() && this.getY() == coordenada.getY();
   }
}