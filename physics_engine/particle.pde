class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  //float damping;
  float invMass; // Inverse of the mass; 0 for immovables
  float r;
  int shotType; //0: pistol, 1: artillery, 2: fireball, 3: laser
  int life;
  PVector forceAccum;

  Particle(float x, float y, float z, int n) {
    pos = new PVector(x, y, z);
    r = 8;

    shotType = n;
    setType(n);

    forceAccum = new PVector(0, 0, 0);
  }

  float mass() {
    if (invMass <= 0) return -1;
    return 1 / invMass;
  }

  void setType(int n) {
    /*
   Sets what type the particle is.
     0: pistol, 1: artillery, 2: fireball, 3: laser
     */
    switch(n) {
    case 0:
      // Pistol
      invMass = 0.5;
      vel = new PVector(350, 0, 0);
      //acc = new PVector(0, 1, 0);
      //damping = 0.9999;
      life = 80;
      break;

    case 1:
      // Artillery
      invMass = 0.0005;
      vel = new PVector(400, -300, 0);
      //acc = new PVector(0, 20, 0);
      //damping = 0.9999;
      life = 60;
      break;

    case 2:
      // Fireball
      invMass = 1;
      vel = new PVector(100, 0, 0);
      //acc = new PVector(0, -0.6, 0);
      //damping = 0.999;
      life = 70;
      break;

    case 3:
      // Laser
      // Note: not realistic!!
      invMass = 10;
      vel = new PVector(1000, 0, 0);
      //acc = new PVector(0, 0, 0);
      //damping = 0.9999;
      life = 90;
      break;

    default:
      // General particle
      invMass = 1;
      vel = new PVector(200, 0, 0);
      //acc = new PVector(0, 2, 0);
      //damping = 0.9999;
      life = -1; // Immortal
      break;
    }
  }

  void show() {
    if (life == 0) return;

    stroke(255);

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(r);
    popMatrix();
  }

  void update() {
    if (life == 0 || invMass <= 0) return;

    acc = PVector.mult(forceAccum, invMass);

    pos.add(PVector.mult(vel, dt));
    pos.add(PVector.mult(acc, 0.5 * dt * dt));

    //vel.mult(damping);
    vel.add(PVector.mult(acc, dt));

    life -= 1;

    forceClear();
  }

  void forceClear() {
    forceAccum = new PVector(0, 0, 0);
  }

  void applyForce(PVector force) {
    forceAccum.add(force);
  }
}
