class Graph {
  //Atributos necesarios para crear un grafo (estatico)
  ArrayList<Node> _nodes;
  int _numlineas;
  int _conexiones[][];
  int _numlineasSuperior;
  int _numlineasInferior;
  // atributos necesarios para jugar el juego (dinamico)
  int _juego[][];
  int _linea[];
  boolean _criterio[];
  int _auxiliar;
  int _ganaste;
  // Default constructor: crea un grafo aleatorio
  Graph() {
    // 1. Instancie nodos
    _nodes = new ArrayList<Node>();
    for (int i = 0; i < random(10, 50); i++)
      _nodes.add(new Node(int(random(0, int(pow(2, _dim)))), int(random(0, int(pow(2, _dim))))));
    // TODO 2. Instancie aristas
    // Se realizó en la función load
  }
  int getNumlineas() {
    return _numlineas;
  }
  Graph(String fileName) {
    load(fileName);
  }
  // Se crea un grafo dinamico a partir de uno estatico
  Graph(Graph other) {
    _criterio = new boolean[3];
    _linea = new int[4];
    _auxiliar = 0;
    _ganaste = 0;
    _juego = new int[other._conexiones.length][other._conexiones.length];
    for (int i=0; i < other._conexiones.length; i++) {
      for (int j=0; j < other._conexiones.length; j++) {
        _juego[i][j]=other._conexiones[i][j];
      }
    }
  }
  //Se carga el nivel
  void load(String filename) {
    //Se accede al nivel
    JSONObject json = loadJSONObject(filename);
    //Se instancia el array list de nodos
    _nodes = new ArrayList<Node>();
    _numlineasSuperior = 0;
    _numlineasInferior = 0;
    //Se accede al array de los nodos
    JSONArray jsonArray1 = json.getJSONArray("nodos");
    //Se accede al array de la matriz de incidencia
    JSONArray jsonArray2 = json.getJSONArray("matriz");
    //Ciclo que recorre el array de los nodos que se encuentra en el .json
    for (int i = 0; i < jsonArray1.size(); i++) {
      //Se accede al objeto i que es de hecho el nodo i del nivel
      JSONObject nodo = jsonArray1.getJSONObject(i);
      //Se accede al objeto con clave position, el cual tiene las posisiones del nodo
      JSONObject position = nodo.getJSONObject("position");
      //Se guardan esta posiciones
      int x = position.getInt("x");
      int y = position.getInt("y");
      //Se instancian los nodos y se agregan al array list de nodos
      _nodes.add( new Node(x, y));
    }
    //Se instancia la matriz de incidencia
    _conexiones = new int[_nodes.size()][_nodes.size()];
    //Ciclo que recorre las filas de la matriz de .json
    for (int i = 0; i < jsonArray2.size(); i++) {
      //Se accede al objeto i que contiene las columnas de la matriz
      JSONObject fila = jsonArray2.getJSONObject(i);
      //Se accede al array i, la cual es la fila i de la matriz
      JSONArray arrayfila = fila.getJSONArray("fila");
      //Ciclo que accede a las columnas de la matriz de .json
      for (int j = 0; j < arrayfila.size(); j++) {
        //Se accede al objeto j de la fila i de la matriz
        JSONObject columna = arrayfila.getJSONObject(j);
        //Se agrega el valor de la matriz de incidencia a la matriz de juego y de incidencia
        _conexiones[i][j] = columna.getInt("valor");
      }
    }
    for (int i=0; i < _conexiones.length; i++) {
      for (int j=0; j < _conexiones.length; j++) {
        if (i<j) {
          if (_conexiones[i][j]>0) {
            _numlineasSuperior+=_conexiones[i][j];
          }
        }
        if (i>j) {
          if (_conexiones[i][j]>0) {
            _numlineasInferior+=_conexiones[i][j];
          }
        }
      }
    }
    if (_numlineasSuperior>=_numlineasInferior) {
      _numlineas=_numlineasSuperior;
    }
    if (_numlineasSuperior<_numlineasInferior) {
      _numlineas=_numlineasInferior;
    }
  }
  // Se implementa para el modo creador, el cual no pude hacer
  void save(String filename) {
    println("Atencion: save por definir!");
  }
  // dibuje el grafo en función de _dim
  void draw() {
    background(180);
    textSize(10);
    text("Press backspace to restart the level", 20, 10);
    text("Press left or right to change the level and then enter to play it", 20, 20);
    // 1. dibuje aristas
    // Recorre la matriz de adyacencia y donde encuentra un 1 se realiza la arista
    for (int i=0; i < _conexiones.length; i++) {
      for (int j=0; j < _conexiones.length; j++) {
        if (_conexiones[i][j]==1) {
          strokeWeight(_nodes.get(0).getWeight()-11);
          stroke(000);
          line(_nodes.get(i).getXposition(), _nodes.get(i).getYposition(), _nodes.get(j).getXposition(), _nodes.get(j).getYposition());
          // Esta parte del codigo se encarga de colocar las flechas para grafos dirigidos en la posicion deseada
          if (_conexiones[i][j]>_conexiones[j][i]) {
            pushMatrix();
            translate(((_nodes.get(i).getXposition()+_nodes.get(j).getXposition())/2), ((_nodes.get(i).getYposition()+_nodes.get(j).getYposition())/2));
            rotate(atan2(_nodes.get(i).getXposition()-((_nodes.get(i).getXposition()+_nodes.get(j).getXposition())/2), ((_nodes.get(i).getYposition()+_nodes.get(j).getYposition())/2)-_nodes.get(i).getYposition()));
            stroke(0, 256, 0);
            line(0, 0, -10, -10);
            line(0, 0, 10, -10);
            popMatrix();
          }
          if (_conexiones[i][j]<_conexiones[j][i]) {
            pushMatrix();
            translate(_nodes.get(i).getXposition(), _nodes.get(i).getYposition());
            rotate(atan2(_nodes.get(j).getXposition()-((_nodes.get(i).getXposition()+_nodes.get(j).getXposition())/2), ((_nodes.get(i).getYposition()+_nodes.get(j).getYposition())/2)-_nodes.get(j).getYposition()));
            stroke(0, 256, 0);
            line(0, 0, -10, -10);
            line(0, 0, 10, -10);
            popMatrix();
          }
        }
        // Si en la matriz de adyacencia se encuentra un 2 quiere decir que se debe pasar 2 veces por lo tanto cambia el color de la arista
        if (_conexiones[i][j]==2) {
          strokeWeight(_nodes.get(0).getWeight()-11);
          stroke(0, 0, 256);
          line(_nodes.get(i).getXposition(), _nodes.get(i).getYposition(), _nodes.get(j).getXposition(), _nodes.get(j).getYposition());
        }
      }
    }
    // 2. dibuje nodos
    for (Node node : _nodes)
      node.draw();
  }
  // Funcion que se usa para jugar el nivel
  void play(Graph grafo) {
    for (int i=0; i<_juego.length; i++) {
      // Se verifica si se esta sobre un nodo y ademas si el click esta presionado
      if (grafo._nodes.get(i).inside(mouseX, mouseY)==true && mousePressed) {
        // Si las variables auxiliares son falsas se guarda la "cola" del segmento
        if (_criterio[0]==false && _criterio[2]==false) {
          // Se eligio la cola del segmento
          _criterio[0]=true;
          // Se guarda la posicion del nodo actual sobre el que estamos haciendo click
          _linea[0]=grafo._nodes.get(i).getXposition();
          _linea[1]=grafo._nodes.get(i).getYposition();
          println("check");
          _auxiliar=i;
        }
        // Se verifica que no sea el mismo punto anterior y que la variable auxiliar sea falsa
        if (_criterio[1]==false && i!=_auxiliar ) {
          // Se eligio la cabeza del segmento
          _criterio[1]=true;
          _criterio[2]=true;
          // Se guarda la posicion del nodo actual sobre el que estamos haciendo click
          _linea[2]=grafo._nodes.get(i).getXposition();
          _linea[3]=grafo._nodes.get(i).getYposition();
          println("check");
          _auxiliar=i;
        }
      }
    }
    // Se realizan los segmentos
    // Se verifica que ya esten seleccionados cabeza y cola de un segmento
    if (_criterio[0]==true && _criterio[1]==true && _criterio[2]==true && mousePressed) {
      // Se asigna color y grosor del segmento
      strokeWeight(16);
      stroke(255, 0, 0);
      // Se recorre la matriz auxiliar que es igual a la de adyacencia
      for (int i=0; i < _juego.length; i++) {
        for (int j=0; j < _juego.length; j++) {
          // Se verifica que la variable auxiliar donde se guardan los puntos iniciales y finales de los segmentos coincidan con los nodos del nivel
          // Ademas se verifica que entre esos puntos hay una conexion
          if (_juego[i][j]==1 && _linea[0]==grafo._nodes.get(i).getXposition() && _linea[1]==grafo._nodes.get(i).getYposition() && _linea[2]==grafo._nodes.get(j).getXposition() && _linea[3]==grafo._nodes.get(j).getYposition()) {
            // Se elimina esta conexion de la matriz auxiliar para que este movimiento no se pueda volver a hacer
            _juego[i][j]=_juego[j][i]=0;
            // Se realiza el segmento
            line(_linea[0], _linea[1], _linea[2], _linea[3]);
            // Se actualiza la cola del siguiente segmento, que va a ser la cabeza del segmento ya dibujado
            _linea[0]=_linea[2];
            _linea[1]=_linea[3];
            _linea[2]=_linea[3]=0;
            _criterio[1]=false;
            // Se creo un nuevo segmento, estas cerca de ganar!
            _ganaste+=1;
            println(_ganaste);
            // Impide que se repita muchas veces este if
            mousePressed=false;
          }
          if (_juego[i][j]==2 && _linea[0]==grafo._nodes.get(i).getXposition() && _linea[1]==grafo._nodes.get(i).getYposition() && _linea[2]==grafo._nodes.get(j).getXposition() && _linea[3]==grafo._nodes.get(j).getYposition()) {
            _juego[i][j]=_juego[j][i]=1;
            line(_linea[0], _linea[1], _linea[2], _linea[3]);
            _linea[0]=_linea[2];
            _linea[1]=_linea[3];
            _linea[2]=_linea[3]=0;
            _criterio[1]=false;
            _ganaste+=1;
            println(_ganaste);
            mousePressed=false;
          }
        }
      }
    }
  }
  // Funcion que se usa para reiniciar el nivel
  void reStart(Graph grafo, String filename ) {
    if (keyPressed==true && key==BACKSPACE) {
      background(180);
      _criterio = new boolean[3];
      _linea = new int[4];
      _auxiliar = 0;
      _ganaste = 0;
      _juego = new int[grafo._conexiones.length][grafo._conexiones.length];
      for (int i=0; i < grafo._conexiones.length; i++) {
        for (int j=0; j < grafo._conexiones.length; j++) {
          _juego[i][j]=grafo._conexiones[i][j];
        }
      }
      grafo.draw();
    }
  }
  // Funcion que se usa para cambiar el nivel
  void changeLevel() {
    if (_currentLevel>=0 && _currentLevel<=6) {  
      if ((keyPressed==true && keyCode==LEFT) && (_currentLevel>0) ) {
        _currentLevel--;
        println(_currentLevel);
        keyPressed=false;
      }
      if ((keyPressed==true && keyCode==RIGHT) && (_currentLevel<6)) {
        _currentLevel++;
        println(_currentLevel);
        keyPressed=false;
      }
    }
  }
  // TODO Defina e implemente un criterio de igualdad que le
  // sirva al juego
  boolean equals(Graph other) {
    // Condicion para ganar
    // Si se realizaron tantos segmentos como hay en el nivel inicialmente
    if (_ganaste==other._numlineas) {
      // Se imprime ganaste
      textSize(50);
      text("Ganaste!", 100, 200);
      return true;
    } else {
      return false;
    }
  }
}
