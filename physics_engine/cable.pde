class Cable extends _Contact {
  float len;

  Cable(Particle p0, Particle p1, float _len) {
    super(p0, p1, 1);
    len = _len;
  }

  boolean colliding() {
    /*
    In this case, "collision" would mean that
     the distance between the particles exceed the length of cable.
     */
    PVector rel_pos = PVector.sub(particles[0].pos, particles[1].pos);
    float thresh = len;
    return (rel_pos.mag() > thresh) && (separatingVelocity() > 0);
  }

  float penetration() {
    /*
    In this case, "penetration" would mean
     the length of extension of the cable, which is impossible.
     */
    float centerDist = PVector.sub(particles[0].pos, particles[1].pos).mag(); 
    return len - centerDist;
  }

  boolean separating() {
    /*
    In this case, there is no need for impulses
     if the distance is already decreasing.
     */
    return separatingVelocity() < 0;
  }
}
