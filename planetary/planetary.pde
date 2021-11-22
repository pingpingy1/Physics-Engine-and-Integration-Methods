final float dt = 0.005, radius = 10, G = 5000000;
final boolean fluctuation = false;
final int seed = 0;
final float prob = 0.1, maxFluc = 0.1;
int frames = 2000;

float invMass1 = 1, invMass2 = 5, dist = 110;
float angularFreq = sqrt(G * (1/invMass1 + 1/invMass2) / pow(dist, 3));

PVector pos1 = new PVector(200 - dist * invMass1 / (invMass1 + invMass2), 150);
PVector pos2 = new PVector(200 + dist * invMass2 / (invMass1 + invMass2), 150);
PVector vel1 = new PVector(0, -dist * invMass1 / (invMass1 + invMass2) * angularFreq);
PVector vel2 = new PVector(0, dist * invMass2 / (invMass1 + invMass2) * angularFreq);

ExplicitEulerParticle e1, e2;
SympleticEulerParticle s1, s2;
VerletParticle v1, v2;

PlanetaryGravityGenerator eg, sg, vg;

float t = 0;

Table xtable1, xtable2, ytable1, ytable2;

void setup() {
  size(400, 300);

  e1 = new ExplicitEulerParticle(pos1.x, pos1.y, vel1.x, vel1.y, invMass1);
  e2 = new ExplicitEulerParticle(pos2.x, pos2.y, vel2.x, vel2.y, invMass2);

  s1 = new SympleticEulerParticle(pos1.x, pos1.y, vel1.x, vel1.y, invMass1);
  s2 = new SympleticEulerParticle(pos2.x, pos2.y, vel2.x, vel2.y, invMass2);

  v1 = new VerletParticle(pos1.x, pos1.y, vel1.x, vel1.y, invMass1);
  v2 = new VerletParticle(pos2.x, pos2.y, vel2.x, vel2.y, invMass2);

  eg = new PlanetaryGravityGenerator(e1, e2);
  sg = new PlanetaryGravityGenerator(s1, s2);
  vg = new PlanetaryGravityGenerator(v1, v2);

  initializeTables();
}

void draw() {
  background(0);

  float x1 = 200 - (200 - pos1.x) * cos(angularFreq * t);
  float y1 = 150 - (200 - pos1.x) * sin(angularFreq * t);
  fill(255);
  circle(x1, y1, 2*radius + 5);

  float x2 = 200 + (pos2.x - 200) * cos(angularFreq * t);
  float y2 = 150 + (pos2.x - 200) * sin(angularFreq * t);
  circle(x2, y2, 2*radius + 5);

  t += dt;

  eg.applyForce();
  sg.applyForce();
  vg.applyForce();

  e1.update();
  e2.update();

  s1.update();
  s2.update();

  v1.update();
  v2.update();

  if (fluctuation) {
    if (random(1) < prob) {
      float flucx1 = maxFluc * random(-1, 1);
      e1.pos.x += flucx1;
      s1.pos.x += flucx1;
      v1.pos.x += flucx1;
    }

    if (random(1) < prob) {
      float flucy1 = maxFluc * random(-1, 1);
      e1.pos.y += flucy1;
      s1.pos.y += flucy1;
      v1.pos.y += flucy1;
    }

    if (random(1) < prob) {
      float flucx2 = maxFluc * random(-1, 1);
      e2.pos.x += flucx2;
      s2.pos.x += flucx2;
      v2.pos.x += flucx2;
    }

    if (random(1) < prob) {
      float flucy2 = maxFluc * random(-1, 1);
      e2.pos.y += flucy2;
      s2.pos.y += flucy2;
      v2.pos.y += flucy2;
    }
  }

  e1.show();
  e2.show();

  s1.show();
  s2.show();

  v1.show();
  v2.show();

  stroke(75);
  line(e1.pos.x, e1.pos.y, e2.pos.x, e2.pos.y);
  line(s1.pos.x, s1.pos.y, s2.pos.x, s2.pos.y);
  line(v1.pos.x, v1.pos.y, v2.pos.x, v2.pos.y);
  line(x1, y1, x2, y2);

  frames -= 1;

  saveCoordinates(x1, y1, x2, y2);

  rec();

  if (frames <= 0) {
    if (fluctuation) {
      saveTable(xtable1, "fluctuation/x1_pos.csv");
      saveTable(xtable2, "fluctuation/x2_pos.csv");
      saveTable(ytable1, "fluctuation/y1_pos.csv");
      saveTable(ytable2, "fluctuation/y2_pos.csv");
    } else {
      saveTable(xtable1, "no_fluctuation/x1_pos.csv");
      saveTable(xtable2, "no_fluctuation/x2_pos.csv");
      saveTable(ytable1, "no_fluctuation/y1_pos.csv");
      saveTable(ytable2, "no_fluctuation/y2_pos.csv");
    }

    noLoop();
  }
}

void initializeTables() {
  xtable1 = new Table();
  xtable1.addColumn("Time");
  xtable1.addColumn("Actual");
  xtable1.addColumn("Explicit Euler");
  xtable1.addColumn("Simpletic Euler");
  xtable1.addColumn("Verlet");

  xtable2 = new Table();
  xtable2.addColumn("Time");
  xtable2.addColumn("Actual");
  xtable2.addColumn("Explicit Euler");
  xtable2.addColumn("Simpletic Euler");
  xtable2.addColumn("Verlet");

  ytable1 = new Table();
  ytable1.addColumn("Time");
  ytable1.addColumn("Actual");
  ytable1.addColumn("Explicit Euler");
  ytable1.addColumn("Simpletic Euler");
  ytable1.addColumn("Verlet");

  ytable2 = new Table();
  ytable2.addColumn("Time");
  ytable2.addColumn("Actual");
  ytable2.addColumn("Explicit Euler");
  ytable2.addColumn("Simpletic Euler");
  ytable2.addColumn("Verlet");

  TableRow xrow1 = xtable1.addRow();
  xrow1.setFloat("Time", 0);
  xrow1.setFloat("Actual", pos1.x);
  xrow1.setFloat("Explicit Euler", pos1.x);
  xrow1.setFloat("Simpletic Euler", pos1.x);
  xrow1.setFloat("Verlet", pos1.x);

  TableRow xrow2 = xtable2.addRow();
  xrow2.setFloat("Time", 0);
  xrow2.setFloat("Actual", pos2.x);
  xrow2.setFloat("Explicit Euler", pos2.x);
  xrow2.setFloat("Simpletic Euler", pos2.x);
  xrow2.setFloat("Verlet", pos2.x);

  TableRow yrow1 = ytable1.addRow();
  yrow1.setFloat("Time", 0);
  yrow1.setFloat("Actual", pos1.y);
  yrow1.setFloat("Explicit Euler", pos1.y);
  yrow1.setFloat("Simpletic Euler", pos1.y);
  yrow1.setFloat("Verlet", pos1.y);

  TableRow yrow2 = ytable2.addRow();
  yrow2.setFloat("Time", 0);
  yrow2.setFloat("Actual", pos2.y);
  yrow2.setFloat("Explicit Euler", pos2.y);
  yrow2.setFloat("Simpletic Euler", pos2.y);
  yrow2.setFloat("Verlet", pos2.y);
}

void saveCoordinates(float x1, float y1, float x2, float y2) {
  TableRow xrow1 = xtable1.addRow();
  xrow1.setFloat("Time", t);
  xrow1.setFloat("Actual", x1);
  xrow1.setFloat("Explicit Euler", e1.pos.x);
  xrow1.setFloat("Simpletic Euler", s1.pos.x);
  xrow1.setFloat("Verlet", v1.pos.x);

  TableRow xrow2 = xtable2.addRow();
  xrow2.setFloat("Time", t);
  xrow2.setFloat("Actual", x2);
  xrow2.setFloat("Explicit Euler", e2.pos.x);
  xrow2.setFloat("Simpletic Euler", s2.pos.x);
  xrow2.setFloat("Verlet", v2.pos.x);

  TableRow yrow1 = ytable1.addRow();
  yrow1.setFloat("Time", t);
  yrow1.setFloat("Actual", y1);
  yrow1.setFloat("Explicit Euler", e1.pos.y);
  yrow1.setFloat("Simpletic Euler", s1.pos.y);
  yrow1.setFloat("Verlet", v1.pos.y);

  TableRow yrow2 = ytable2.addRow();
  yrow2.setFloat("Time", t);
  yrow2.setFloat("Actual", y2);
  yrow2.setFloat("Explicit Euler", e2.pos.y);
  yrow2.setFloat("Simpletic Euler", s2.pos.y);
  yrow2.setFloat("Verlet", v2.pos.y);
}
