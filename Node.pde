class Node {
  // coordenadas (x, y) del centro del nodo
  int _x;
  int _y;
  // radio del nodo
  int _radius;
  // color del contorno
  color _stroke;
  // ancho del nodo
  int _weight;
  // color del nodo
  color _fill;
  Node _nodo;
  // getters y setters para todos los atributos del nodo
  int getXposition() {
    return _x;
  }
  int getYposition() {
    return _y;
  }
  int getRadius() {
    return _radius;
  }
  int getWeight() {
    return _weight;
  }
  color getStroke() {
    return _stroke;
  }
  color getFill() {
    return _fill;
  }
  void setXposition(int newX) {
    _x = newX;
  }
  void setYposition(int newY) {
    _y = newY;
  }
  void setRadius(int newRadius) {
    _radius = newRadius;
  }
  void setWeight(int newWeight) {
    _weight = newWeight;
  }
  void setstroke(color newStroke) {
    _stroke = newStroke;
  }
  void setfill(color newFill) {
    _fill = newFill;
  }
  // Default constructor crea un nodo aleatorio:
  Node() {
    // empleando coord de pantalla de modo
    // que el nodo se circunscriba a la pantalla
    _x = int(random(0, int(pow(2, _dim))));
    _y = int(random(0, int(pow(2, _dim))));
    _radius = int(random(30, 60));
    _stroke = color(random(255), random(255), random(255));
  }
  Node(int x, int y) {
    _x = x;
    _y = y;
    _radius = 16;
    _fill = color(255, 0, 0);
    _weight = 16;
  }

  // Dibuja los nodos con el color y ancho por defecto, en la posicion indicada
  void draw() {
    push();
    stroke(_fill);
    strokeWeight(_weight);
    point(_x, _y);
    pop();
  }
  // función que verifica si el mouse se encuentra sobre el nodo
  boolean inside(int x, int y) {
    float disX = x - _x;
    float disY = y - _y;
    if (pow(disX, 2) + pow(disY, 2) <= pow(_radius, 2)) {
      return true;
    } else {
      return false;
    }
  }
}
