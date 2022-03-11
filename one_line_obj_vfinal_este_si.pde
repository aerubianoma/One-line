import ddf.minim.*;
//Musica del juego
Minim minim;
AudioPlayer player;
// Array list con los niveles del juego (estatico)
ArrayList<Graph> _levels;
// Array list con lo necesario para jugar cada nivel del juego, cada nivel posee dos grafos distintos (dinamico)
ArrayList<Graph> _games;
// 0 por defecto
int _currentLevel;
// Imagen de inicio
PImage img;
// Tamaño de la ventana es 2^_dim
float _dim = 9.8;
void settings() {
  size(400, 400);
}
void setup() {
  //Se agregan los niveles al array list
  _levels = new ArrayList<Graph>();
  for (int i=0; i<7; i++) {
    _levels.add(new Graph("nivel"+str(i)+".json"));
  }
  //Se agrega lo necesario para jugar cada nivel al array list, que depende de su respectivo grafo de representación
  _games = new ArrayList<Graph>();
  for (int i=0; i<_levels.size(); i++) {
    _games.add(new Graph(_levels.get(i)));
  }
  // Inicio y musica del juego
  img = loadImage("inicio.jpg");
  image(img, 0, 0);
  textSize(28);
  fill(#000000);  
  text("Press enter to start", 70, 100);
  minim = new Minim(this);
  player = minim.loadFile("musica_fondo.mp3");
  player.loop();
}
void draw() {
  //Para poder cambiar los niveles
  _games.get(_currentLevel).changeLevel();
  //Para dibujar los niveles
  if (keyPressed==true && key==ENTER) {
    _levels.get(_currentLevel).draw();
  }
  //Para reiniciar los niveles
  _games.get(_currentLevel).reStart(_levels.get(_currentLevel), "nivel"+str(_currentLevel)+".json");
  //Para jugar los niveles
  _games.get(_currentLevel).play(_levels.get(_currentLevel));
  //Para verificar que se haya pasado un nivel
  _games.get(_currentLevel).equals(_levels.get(_currentLevel));
}
//Para que la musica no haga cosas extrañas
void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

// TODO Implemente la interacción del juego teniendo
// presente las siguientes restricciones:
// 1. Ratón para jugar
// 2. Teclas para el resto
