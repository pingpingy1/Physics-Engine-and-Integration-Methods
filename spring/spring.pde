final float dt = 0.005, radius = 10;
final boolean fluctuation = true;
final int seed = 0;
final float prob = 0.1, maxFluc = 0.1;
int frames = 2000;

float springConst = 8, inverseMass = 1;
float angularFreq = sqrt(springConst * inverseMass);
PVector pos0 = new PVector(300, 150);
PVector vel0 = new PVector(20, -100);

ExplicitEulerParticle e1;
SympleticEulerParticle s1;
VerletParticle v1;

AnchoredSpring es, ss, vs;

float t = 0;

Table xtable, ytable;

void setup() {
  size(400, 300);

  e1 = new ExplicitEulerParticle(pos0.x, pos0.y, vel0.x, vel0.y, inverseMass);
  s1 = new SympleticEulerParticle(pos0.x, pos0.y, vel0.x, vel0.y, inverseMass);
  v1 = new VerletParticle(pos0.x, pos0.y, vel0.x, vel0.y, inverseMass);

  es = new AnchoredSpring(e1, 200, 150, springConst, 0);
  ss = new AnchoredSpring(s1, 200, 150, springConst, 0);
  vs = new AnchoredSpring(v1, 200, 150, springConst, 0);

  initializeTables();
}

void draw() {
  background(0);

  float x = 200 + (pos0.x - 200) * cos(angularFreq * t) + vel0.x / angularFreq * sin(angularFreq * t);
  float y = 150 + (pos0.y - 150) * cos(angularFreq * t) + vel0.y / angularFreq * sin(angularFreq * t);
  fill(255);
  circle(x, y, 2*radius + 5);
  t += dt;

  es.applyForce();
  ss.applyForce();
  vs.applyForce();

  e1.update();

  s1.update();

  v1.update();

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
  }

  e1.show();

  s1.show();

  v1.show();

  stroke(75);
  line(e1.pos.x, e1.pos.y, 200, 150);
  line(s1.pos.x, s1.pos.y, 200, 150);
  line(v1.pos.x, v1.pos.y, 200, 150);
  line(x, y, 200, 150);

  frames -= 1;

  saveCoordinates(x, y);

  rec();

  if (frames <= 0) {
    if (fluctuation) {
      saveTable(xtable, "fluctuation/x_pos.csv");
      saveTable(ytable, "fluctuation/y_pos.csv");
    } else {
      saveTable(xtable, "no_fluctuation/x_pos.csv");
      saveTable(ytable, "no_fluctuation/y_pos.csv");
    }

    noLoop();
  }
}

void initializeTables() {
  xtable = new Table();
  xtable.addColumn("Time");
  xtable.addColumn("Actual");
  xtable.addColumn("Explicit Euler");
  xtable.addColumn("Simpletic Euler");
  xtable.addColumn("Verlet");

  ytable = new Table();
  ytable.addColumn("Time");
  ytable.addColumn("Actual");
  ytable.addColumn("Explicit Euler");
  ytable.addColumn("Simpletic Euler");
  ytable.addColumn("Verlet");

  TableRow xrow = xtable.addRow();
  xrow.setFloat("Time", 0);
  xrow.setFloat("Actual", pos0.x);
  xrow.setFloat("Explicit Euler", pos0.x);
  xrow.setFloat("Simpletic Euler", pos0.x);
  xrow.setFloat("Verlet", pos0.x);

  TableRow yrow = ytable.addRow();
  yrow.setFloat("Time", 0);
  yrow.setFloat("Actual", pos0.y);
  yrow.setFloat("Explicit Euler", pos0.y);
  yrow.setFloat("Simpletic Euler", pos0.y);
  yrow.setFloat("Verlet", pos0.y);
}

void saveCoordinates(float x, float y) {
  TableRow xrow = xtable.addRow();
  xrow.setFloat("Time", t);
  xrow.setFloat("Actual", x);
  xrow.setFloat("Explicit Euler", e1.pos.x);
  xrow.setFloat("Simpletic Euler", s1.pos.x);
  xrow.setFloat("Verlet", v1.pos.x);

  TableRow yrow = ytable.addRow();
  yrow.setFloat("Time", t);
  yrow.setFloat("Actual", y);
  yrow.setFloat("Explicit Euler", e1.pos.y);
  yrow.setFloat("Simpletic Euler", s1.pos.y);
  yrow.setFloat("Verlet", v1.pos.y);
}
