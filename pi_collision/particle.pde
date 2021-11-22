class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  //float damping;
  float invMass; // Inverse of the mass; 0 for immovables
  float r;
  PVector forceAccum;

  Particle(float x, float y, float vx, float vy, float invM) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    acc = new PVector(0, 0);
    r = radius;
    invMass = invM;

    forceAccum = new PVector(0, 0);
  }

  float mass() {
    if (invMass <= 0) return -1;
    return 1 / invMass;
  }

  void show() {
    noStroke();
    
    pushMatrix();
    translate(pos.x, pos.y);
    circle(0, 0, 2*r);
    popMatrix();
  }

  void update() {
    return;
  }

  void forceClear() {
    forceAccum = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    forceAccum.add(force);
  }
}

class ExplicitEulerParticle extends Particle {
  ExplicitEulerParticle(float x, float y, float vx, float vy, float invM) {
    super(x, y, vx, vy, invM);
  }

  void show() {
    fill(255, 0, 0);
    super.show();
  }

  void update() {
    if (invMass <= 0) return;

    acc = PVector.mult(forceAccum, invMass);

    pos.add(PVector.mult(vel, dt));

    vel.add(PVector.mult(acc, dt));

    forceClear();
  }
}

class SympleticEulerParticle extends Particle {
  SympleticEulerParticle(float x, float y, float vx, float vy, float invM) {
    super(x, y, vx, vy, invM);
  }

  void show() {
    fill(0, 255, 0);
    super.show();
  }
  void update() {
    if (invMass <= 0) return;

    acc = PVector.mult(forceAccum, invMass);

    vel.add(PVector.mult(acc, dt));

    pos.add(PVector.mult(vel, dt));

    forceClear();
  }
}
