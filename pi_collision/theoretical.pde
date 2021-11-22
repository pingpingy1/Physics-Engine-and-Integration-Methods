// From Galperin's "Playing Pool with Pi" paper

// First, save the cosine and sine values
// of even multiples of arctan(sqrt(invMass1 / invMass2)).
int N = ceil(HALF_PI / atan(sqrt(invMass1 / invMass2)));
float[] cosines = new float[N];  // cosines[i] = cos(2*(i+1)*theta0)
float[] sines = new float[N];    // sines[i] = sin(2*(i+1)*theta0)

void calcTrig() {
  cosines[0] = (-invMass1 + invMass2) / (invMass1 + invMass2);
  sines[0] = (2*sqrt(invMass1*invMass2)) / (invMass1 + invMass2);
  for (int n = 1; n < N; n++) {
    // cos(2*n*theta0) + i*sin(2*n*theta0)
    // = (cos(2*(n-1)*theta0) + i*sin(2*(n-1)*theta0))
    // * (cos(2*theta0) + i*sin(2*theta0))
    cosines[n] = cosines[n-1] * cosines[0] - sines[n-1] * sines[0];
    sines[n] = sines[n-1] * cosines[0] + cosines[n-1] * sines[0];
  }
}

// As calculated, multiple reflections is either reflection or rotation.
// Given some reflected coordinate in the phase space,
// we need to calculate the actual coordinates.

float acot(float x) {
  return HALF_PI - atan(x);
}

float[] coordinates(float t) {
  // Using t, the phase space coordinates are as follows.
  float q1 = sqrt(invMass2) * (x01 - v0 * t - wallx - 4*radius);
  float q2 = sqrt(invMass1) * (x02 - wallx - 2*radius);

  int n = floor(acot(q1/q2) / atan(sqrt(invMass1 / invMass2)));

  float originalq1, originalq2;

  if (n == 0) {
    originalq1 = q1;
    originalq2 = q2;
  } else if (n%2 == 0) {
    originalq1 = cosines[n/2-1] * q1 + sines[n/2-1] * q2;
    originalq2 = -sines[n/2-1] * q1 + cosines[n/2-1] * q2;
  } else {
    originalq1 = cosines[(n-1)/2] * q1 + sines[(n-1)/2] * q2;
    originalq2 = sines[(n-1)/2] * q1 - cosines[(n-1)/2] * q2;
  }

  float[] coord = {originalq1/sqrt(invMass2) + wallx + 4*radius, originalq2/sqrt(invMass1) + wallx + 2*radius};
  return coord;
}
