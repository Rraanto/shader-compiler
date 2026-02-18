#version 460 core

#define THICKNESS 0.0015

/*
 * Outputs a grid with circles for 
 * easier configuration of camera 
 */

out vec4 FragColor; // color output 
in vec2 vPos; // read from vertex shader output

// uniforms 
uniform vec2 uCenter;
uniform float uScale; 
uniform float uAspect; // aspect ratio 
uniform float uTime; 

vec3 hsv2rgb(vec3 c);
vec2 cmul(vec2 u, vec2 v);
vec2 complexSin(vec2 z);
vec2 complexCos(vec2 z);
vec2 retract_to_circle(vec2 pos, float r, float t);
vec2 comp_exp(vec2 z);
vec2 retract_inverse(vec2 p, float r, float t);
vec3 convergence_track(vec2 z0, int max_iters);

// dynamical system coloring 
vec2 f(vec2 z, vec2 z0) {
  return cmul(z, z) + z0;
}

void main() {
  float scale = uScale; 
  vec2 position = vPos; 

  // abstract to scene processing
  position = scale * position + uCenter; 
  position.x *= uAspect; 

  // abstract transformations
  float t = (1.0 + sin(uTime)) / 2.0; 
  // position = retract_inverse(position, 1.0, t);
  // position = comp_exp(position);
  
  int max_iters = 1000;

  FragColor = vec4(convergence_track(position, max_iters), 1.0);

  /* To show a grid instead 
  if ( abs(fract(length(position))) / 2.0 <= THICKNESS * uScale) {
    FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  } else 
  
  if (
     ( abs(position.x - round(position.x)) <= THICKNESS * uScale ) || 
     abs(position.y - round(position.y)) <= THICKNESS * uScale
    )
  {
    FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  }

  else {
    FragColor = vec4(0.0, 0.0, 0.0, 0.0);
  }
  */
}

vec2 cmul(vec2 u, vec2 v) {
  // (a + ib) (c + id) 
  // ac + i(ad) + i(bc) - bd 
  // (ac - bd) + i(ad + bc)
  float a = u.x; 
  float b = u.y; 
  float c = v.x; 
  float d = v.y; 
  return vec2(a*c - b*d, a*d + b*c);
}

vec2 complexSin(vec2 z) {
  float x = z.x;
  float y = z.y;
  return vec2(sin(x) * cosh(y), cos(x) * sinh(y));
}

vec2 complexCos(vec2 z) {
  float x = z.x;
  float y = z.y;
  return vec2(cos(x) * cosh(y), -sin(x) * sinh(y));
}

// Assumes you have:
//   vec2 f(vec2 z, vec2 z0);
//   vec3 hsv2rgb(vec3 c);   // if you want the HSV palette below
//
// Returns black for points that do not escape within max_iters.
vec3 convergence_track(vec2 z0, int max_iters)
{
    vec2 z = vec2(0.0);
    int iteration = 0;

    for (iteration = 0; iteration < max_iters; ++iteration) {
        z = f(z, z0);
        if (dot(z, z) > 4.0) break;  // escape radius 2
    }

    // Inside set
    if (iteration == max_iters) return vec3(0.0);

    // Smooth escape (matches your block)
    float mag = length(z);
    mag = max(mag, 1e-8);

    float mu = float(iteration) + 1.0 - log2(log(mag));
    mu = clamp(mu / float(max_iters), 0.0, 1.0);

    float intensity = 30.0 * pow(mu, 0.7);

    // HSV palette (same parameters)
    float h = fract(0.95 + 10.0 * intensity);
    float s = 0.85;
    float v = 1.0;

    // return hsv2rgb(vec3(h, s, v));

    // If you want the trig palette instead, return this:
    return vec3(pow(cos(intensity), 2.0),
               pow(sin(intensity), 2.0),
              1.0 - mu);
}

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

vec2 comp_exp(vec2 z) {
  // complex exponential exp(z)
  float a = exp(z.x) * cos(z.y);
  float b = exp(z.y) * sin(z.y);
  return vec2(a, b);
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
