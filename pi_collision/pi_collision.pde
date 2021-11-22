final float dt = 0.005, radius = 10;
int frames = 500;

final float wallx = 90, x01 = 250, x02 = 150, v0 = 100, invMass1 = 1, invMass2 = 100;

Particle ewall, swall;
ExplicitEulerParticle e1, e2;
SympleticEulerParticle s1, s2;

Contact ec, sc;

float t = 0;

Table xtable1, xtable2;

void setup() {
  size(400, 300);


  ewall = new Particle(wallx, 150, 0, 0, -1);
  e1 = new ExplicitEulerParticle(x01, 150, -v0, 0, invMass1);
  e2 = new ExplicitEulerParticle(x02, 150, 0, 0, invMass2);

  swall = new Particle(wallx, 225, 0, 0, -1);
  s1 = new SympleticEulerParticle(x01, 225, -v0, 0, invMass1);
  s2 = new SympleticEulerParticle(x02, 225, 0, 0, invMass2);

  ec = new Contact(ewall, e1, e2);
  sc = new Contact(swall, s1, s2);

  calcTrig();

  initializeTables();
}

void draw() {
  background(0);

  stroke(255);
  strokeWeight(1);
  line(wallx + radius, 0, wallx + radius, height);

  t += dt;

  float[] coord = coordinates(t);
  fill(255);
  circle(coord[0], 75, 2*radius);
  circle(coord[1], 75, 2*radius);

  ec.resolve();
  sc.resolve();

  e1.update();
  e1.show();
  e2.update();
  e2.show();

  s1.update();
  s1.show();
  s2.update();
  s2.show();

  stroke(255, 100);
  line(coord[0], 0, coord[0], height);
  line(coord[1], 0, coord[1], height);

  stroke(255, 0, 0, 100);
  line(e1.pos.x, 0, e1.pos.x, height);
  line(e2.pos.x, 0, e2.pos.x, height);

  stroke(0, 255, 0, 100);
  line(s1.pos.x, 0, s1.pos.x, height);
  line(s2.pos.x, 0, s2.pos.x, height);

  frames -= 1;

  saveCoordinates(coord[0], coord[1]);
  rec();

  if (frames <= 0) {
    saveTable(xtable1, "data/x1_pos.csv");
    saveTable(xtable2, "data/x2_pos.csv");

    noLoop();
  }
}

void initializeTables() {
  xtable1 = new Table();
  xtable1.addColumn("Time");
  xtable1.addColumn("Actual");
  xtable1.addColumn("Explicit Euler");
  xtable1.addColumn("Simpletic Euler");

  xtable2 = new Table();
  xtable2.addColumn("Time");
  xtable2.addColumn("Actual");
  xtable2.addColumn("Explicit Euler");
  xtable2.addColumn("Simpletic Euler");

  TableRow xrow1 = xtable1.addRow();
  xrow1.setFloat("Time", 0);
  xrow1.setFloat("Actual", x01);
  xrow1.setFloat("Explicit Euler", x01);
  xrow1.setFloat("Simpletic Euler", x01);

  TableRow xrow2 = xtable2.addRow();
  xrow2.setFloat("Time", 0);
  xrow2.setFloat("Actual", x02);
  xrow2.setFloat("Explicit Euler", x02);
  xrow2.setFloat("Simpletic Euler", x02);
}

void saveCoordinates(float x1, float x2) {
  TableRow xrow1 = xtable1.addRow();
  xrow1.setFloat("Time", t);
  xrow1.setFloat("Actual", x1);
  xrow1.setFloat("Explicit Euler", e1.pos.x);
  xrow1.setFloat("Simpletic Euler", s1.pos.x);

  TableRow xrow2 = xtable2.addRow();
  xrow2.setFloat("Time", t);
  xrow2.setFloat("Actual", x2);
  xrow2.setFloat("Explicit Euler", e2.pos.x);
  xrow2.setFloat("Simpletic Euler", s2.pos.x);
}
