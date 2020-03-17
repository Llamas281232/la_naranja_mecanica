// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Basic example of controlling an object with our own motion (by attaching a MouseJoint)
// Also demonstrates how to know which object was hit

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import ddf.minim.*;
Minim  minim;
AudioPlayer cancion;
PImage alex;
PImage clock;
PantallaDeCarga c;
PFont letras;

// A reference to our box2d world
Box2DProcessing box2d;

// Just a single box this time
Box box;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// The Spring that will attach to the box from the mouse
Spring spring;

// Perlin noise values
float xoff = 0;
float yoff = 1000;


void setup() {
  size(600,600);
  smooth();
 size(600,600);
  c = new PantallaDeCarga();
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Turn on collision listening!
  box2d.listenForCollisions();

  // Make the box
  box = new Box(width/2,height/2);

  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();
  spring.bind(width/2,height/2,box);
  alex = loadImage ("Alex.png");
  alex.resize (25,35);
  clock = loadImage ("clock.png");
  clock.resize (40,50);
  minim = new Minim(this);
  cancion = minim.loadFile("WAV_NaranjaMecanica.wav");
  cancion.play();

  

  // Create the empty list
  particles = new ArrayList<Particle>();


}

void draw() {
  background(255);
  c.Cambio(); 

  if (random(1) < 0.028) {
    float sz = random(4,8);
    particles.add(new Particle(width/2,-20,sz));
  }
  


  // We must always step through time!
  box2d.step();

  // Make an x,y coordinate out of perlin noise
  float x = noise(xoff)*width;
  float y = noise(yoff)*height;
  xoff += 0.01;
  yoff += 0.01;

  // This is tempting but will not work!
  // box.body.setXForm(box2d.screenToWorld(x,y),0);

  // Instead update the spring which pulls the mouse along
  if (mousePressed) {
    spring.update(mouseX,mouseY);
    spring.display();
  } else {
    spring.update(x,y);
  }
  box.body.setAngularVelocity(0);

  // Look at all particles
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (p.done()) {
      particles.remove(i);
    }
  }

  // Draw the box
  box.display();

  // Draw the spring
  // spring.display();
}
class PantallaDeCarga{
 int p = 0;
 color col;
 int vida = 300;
 PantallaDeCarga (){
 
}
void Cambio(){
  if(p == 0)
  pan1();
  if(p==1);
  }
void pan1(){
  background(#FF6748);
  if (mouseX>111 && mouseX < 483 && mouseY>36 && mouseY < 76)
  fill (random(255),0,0);
  else
  fill(random(255));
  letras = loadFont ("BernardMT-Condensed-48.vlw");
  textFont(letras,50);
  textAlign(CENTER);
  
  text("Golpea La Musica",300,75);
  textSize(15);
  textAlign(CENTER);
  text("¡INSTRUCCIONES!",300,500);
  textSize(15);
  textAlign(CENTER);
  text("Golpea a los Alex's para que la musica siga, no falles",300,515);
  textSize(15);
  textAlign(CENTER);
  text("¡Golpea hasta que la melodía se acabe ¡¡NO PIERDAS!! !",300,530);
  
}
}


// Collision event functions!
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  // If object 1 is a Box, then object 2 must be a particle
  // Note we are ignoring particle on particle collisions
  if (o1.getClass() == Box.class) {
    Particle p = (Particle) o2;
    p.change();
  } 
  // If object 2 is a Box, then object 1 must be a particle
  else if (o2.getClass() == Box.class) {
    Particle p = (Particle) o1;
    p.change();
  }
}


// Objects stop touching each other
void endContact(Contact cp) {
}
