class Rod extends Cable {

  Rod(Particle p0, Particle p1, float _len) {
    super(p0, p1, _len);
  }

  boolean extending() {
    PVector rel_pos = PVector.sub(particles[0].pos, particles[1].pos);
    return (rel_pos.mag() > len) && (separatingVelocity() > 0);
  }

  boolean compressing() {
    PVector rel_pos = PVector.sub(particles[0].pos, particles[1].pos);
    return (rel_pos.mag() < len) && (separatingVelocity() < 0);
  }

  boolean colliding() {
    /*
    In this case, "collision" would mean
     either extending or compressing.
     */
    return extending() || compressing();
  }
  
  boolean separating() {
    /*
    In this case, there is no need for impulses
     if the distance is already restoring to natural length.
     */
    return (extending() && separatingVelocity() < 0) || (compressing() && separatingVelocity() > 0);
  }
}
