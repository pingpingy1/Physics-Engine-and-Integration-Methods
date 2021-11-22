class Contact {
  Particle[] particles;
  _Contact[] contacts;
  
  Contact(Particle ...ps){
    int n = ps.length;
    particles = new Particle[n];
    for (int i = 0; i < n; i++) particles[i] = ps[i];
    
    contacts = new _Contact[n * (n-1) / 2];
    int idx = 0;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < i; j++) {
        _Contact temp = new _Contact(ps[i], ps[j], 1);
        contacts[idx] = temp;
        idx++;
      }
    }
  }
  
  void resolve() {
    for (_Contact c : contacts) c.resolve();
  }
}

class _Contact {
  Particle[] particles = new Particle[2];
  float restitution;

  _Contact(Particle p0, Particle p1, float _restitution) {
    if (p0.invMass <= 0 && p1.invMass <= 0) {
      throw new IllegalArgumentException("Both particles are immovable!");
    }
    particles[0] = p0;
    particles[1] = p1;
    restitution = _restitution;
  }

  float separatingVelocity() {
    PVector rel_vel = PVector.sub(particles[0].vel, particles[1].vel);
    PVector rel_pos = PVector.sub(particles[0].pos, particles[1].pos);
    return PVector.dot(rel_vel, rel_pos.normalize());
  }

  boolean colliding() {
    PVector rel_pos = PVector.sub(particles[0].pos, particles[1].pos);
    float thresh = particles[0].r + particles[1].r + 1;
    return (rel_pos.mag() < thresh) && (separatingVelocity() < 0);
  }

  PVector contactNormal() {
    /*
    The normal vector points from particles[1] to particles[0].
     Thus, the impulse on [0] should be in the same direction;
     that on [1] should be in the opposite direction.
     
     For now, all objects are spherical (circular),
     so the normal vector is parallel to the difference in positions.
     */
    return PVector.sub(particles[0].pos, particles[1].pos).normalize();
  }

  float penetration() {
    /*
    The distance the two objects have penetrated;
     this only happens because time is discretized.
     */
    float centerDist = PVector.sub(particles[0].pos, particles[1].pos).mag(); 
    return centerDist - particles[0].r - particles[1].r;
  }

  void resolvePenetration() {
    float l = penetration();
    if (l <= 0) return;

    PVector normal = contactNormal();

    float m0 = particles[0].mass();
    float m1 = particles[1].mass();

    if (m0 <= 0) {
      particles[1].pos.add(normal.mult(-l));
      return;
    }
    if (m1 >= 0) {
      particles[0].pos.add(normal.mult(l));
      return;
    }

    float l0 = l * m0 / (m0 + m1);
    float l1 = l * m1 / (m0 + m1);

    particles[0].pos.add(PVector.mult(normal, l0));
    particles[1].pos.add(PVector.mult(normal, -l1));
  }

  boolean separating() {
    /*
    There is no need in applying impulses
     if the particles are already separating.
     */
    return separatingVelocity() > 0;
  }

  void resolveVelocity() {
    PVector normal = contactNormal();
    float sep = separatingVelocity();
    if (separating()) return;
    float newsep = -sep * restitution;

    // Resolving stationary contact
    PVector relAcc = PVector.sub(particles[0].acc, particles[1].acc);
    float accCausedSepVel = PVector.dot(relAcc, normal) * dt;
    if (accCausedSepVel < 0) {
      /*
      This means that, had it not been for acceleration,
       the two objects would not have "collided".
       They would instead just be in contact.
       */
      newsep += restitution * accCausedSepVel;
      if (newsep < 0) newsep = 0;
    }

    float deltaVel = newsep - sep;

    // Change in velocity inversely proportional to mass
    float m0 = particles[0].mass();
    float m1 = particles[1].mass();

    if (m0 <= 0) {
      particles[1].vel.add(PVector.mult(normal, -deltaVel));
      return;
    }
    if (m1 <= 0) {
      particles[0].vel.add(PVector.mult(normal, deltaVel));
      return;
    }

    float impulsePerMass = deltaVel / (m0 + m1);
    particles[0].vel.add(PVector.mult(normal, impulsePerMass * m1));
    particles[1].vel.add(PVector.mult(normal, -impulsePerMass * m0));
  }

  void resolve() {
    if (colliding()) {
      resolveVelocity();
      resolvePenetration();
    }
  }
}
