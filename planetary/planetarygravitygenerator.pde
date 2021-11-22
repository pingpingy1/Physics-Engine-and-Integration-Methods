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
      
      for (int j = 0; j < i; j++) {
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
