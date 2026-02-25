// retracts the punctured plane into a circle of radius r
vec2 retract_to_circle(vec2 pos, float r, float t) {
  return (1.0 - t) * pos + t * r * normalize(pos);
}

vec2 retract_inverse(vec2 p, float r, float t)
{
    float rho = length(p);
    if (rho < 0.01) return p;
    vec2 u = p / rho;
    float rho0 = (rho - t * r) / (1.0 - t); // inverse of rho' = (1-t)rho + t r
    return rho0 * u;
}

