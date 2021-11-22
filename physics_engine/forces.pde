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

class GravityGenerator extends ForceGenerator {
  GravityGenerator(Particle ...ps) {
    super(ps);
  }

  float gravAcc(int n) {
    /*
    The gravitational acceleration should vary
     depending on the each type of projectile.
     */

    switch(n) {
    case 0:
      return 1;

    case 1:
      return 20;

    case 2:
      return -0.6;

    case 3:
      return 0;
    }

    return 2;
  }

  PVector calcForce(Particle p) {
    PVector g = new PVector(0, gravAcc(p.shotType));
    return PVector.mult(g, p.mass());
  }
}

class DragGenerator extends ForceGenerator {
  DragGenerator(Particle ...ps) {
    super(ps);
  }

  float linCoeff(int n) {
    if (n == 2) return 0.001;
    return 0.0001;
  }

  float quadCoeff(int n) {
    if (n == 2) return 0.00001;
    return 0.000001;
  }

  PVector calcForce(Particle p) {
    float k1 = linCoeff(p.shotType);
    float k2 = quadCoeff(p.shotType);

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

  AnchoredSpring(Particle _p, float x, float y, float z, float _k, float _l0) {
    p = _p;
    anchor = new PVector(x, y, z);
    k = _k;
    l0 = _l0;
  }
  
  void applyForce() {
    PVector r = PVector.sub(anchor, p.pos); // Directed from p to anchor
    float mag = k * (r.mag() - l0);
    p.applyForce(r.setMag(mag));
  }
}

class Bungee extends Spring {
  Bungee(Particle p1, Particle p2, float _k, float _l0) {
    super(p1, p2, _k, _l0);
  }
  
  PVector calcForce() {
    PVector r = PVector.sub(p1.pos, p2.pos);
    
    if (r.mag() <= l0) return new PVector(0, 0, 0);
    
    return super.calcForce();
  }
}

class PlanetaryGravityGenerator {
  ArrayList<Particle> particles;

  PlanetaryGravityGenerator(Particle ...ps) {
    particles = new ArrayList<Particle>();

    for (Particle p : ps) {
      particles.add(p);
    }
  }

  void applyForce() {
    /*
    As each pair of particles results in their own set of forces,
     it is inefficient to calculate the force and then apply them.
     Instead, each force is applied right away.
     */

    int n = particles.size();

    for (int i = 0; i < n; i++) {
      Particle p = particles.get(i);
      if (p.invMass <= 0) continue;
      
      for (int j = 0; j <= i; j++) {
        Particle q = particles.get(j);

        PVector relPos = PVector.sub(p.pos, q.pos);    // Directed from q to p
        
        if (q.invMass <= 0 || relPos.mag() <= 1) continue;
        
        float magnitude = G * p.mass() * q.mass() / pow(relPos.mag(), 2);
        relPos.setMag(magnitude);
        
        q.applyForce(relPos);
        p.applyForce(relPos.mult(-1));
      }
    }
  }
}
