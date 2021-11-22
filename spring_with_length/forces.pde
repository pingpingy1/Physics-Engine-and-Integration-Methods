class ForceGenerator {
  ArrayList<Particle> particles;

  ForceGenerator(Particle ...ps) {
    particles = new ArrayList<Particle>();

    for (Particle p : ps) {
      particles.add(p);
    }
  }

  PVector calcForce(Particle p) {
    return new PVector(0, 0, 0);
  }

  void applyForce() {
    for (Particle p : particles) {
      PVector f = calcForce(p);
      p.applyForce(f);
    }
  }
}

class DragGenerator extends ForceGenerator {
  DragGenerator(Particle ...ps) {
    super(ps);
  }

  PVector calcForce(Particle p) {
    /*
    Drag force is composed of two terms: linear and quadratic terms.
     Their respective coefficients are k1 and k2.
     */
    float k1 = 0.1;
    float k2 = 0.001;

    float f1 = k1 * p.vel.mag();
    float f2 = k2 * p.vel.mag() * p.vel.mag();
    PVector dir = PVector.mult(p.vel, -1);

    return dir.setMag(f1 + f2);
  }
}

class Spring extends ForceGenerator {
  float k;
  float l0;

  Spring(Particle p1, Particle p2, float _k, float _l0) {
    super(p1, p2);
    k = _k;
    l0 = _l0;
  }

  PVector calcForce() {
    /*
    Calculates the force for the first particle.
     */
    PVector r = PVector.sub(particles.get(1).pos, particles.get(0).pos);
    float mag = k * (r.mag() - l0);

    return r.setMag(mag);
  }

  void applyForce() {
    PVector f = calcForce();
    particles.get(0).applyForce(f);
    particles.get(1).applyForce(f.mult(-1));
  }
}

class AnchoredSpring {
  Particle p;
  PVector anchor;
  float k;
  float l0;

  AnchoredSpring(Particle _p, float x, float y, float _k, float _l0) {
    p = _p;
    anchor = new PVector(x, y);
    k = _k;
    l0 = _l0;
  }
  
  void applyForce() {
    PVector r = PVector.sub(anchor, p.pos); // Directed from p to anchor
    float mag = k * (r.mag() - l0);
    p.applyForce(r.setMag(mag));
  }
}
