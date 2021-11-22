final float dt = 0.005, G = 10000;

Particle p1, p2;
//DragGenerator d;
//Bungee b;
//Contact cont;
//Cable cable;
Rod rod;

void setup() {
  size(800, 600, P3D);
  p1 = new Particle(400, 100, 0, 4);
  p2 = new Particle(400, 500, 0, 4);
  p1.vel.mult(-1);

  //d = new DragGenerator(p1, p2);

  //b = new Bungee(p1, p2, 0.1, 400);

  //cont = new Contact(p1, p2, 1);
  //cable = new Cable(p1, p2, 450);
  rod = new Rod(p1, p2, 400);
}

void draw() {
  background(0);

  //d.applyForce();
  //b.applyForce();
  //cont.resolve();
  //cable.resolve();
  rod.resolve();

  p1.update();
  p1.show();
  p2.update();
  p2.show();
  
}
