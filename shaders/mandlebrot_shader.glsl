#version 460 core
out vec4 FragColor;
in vec2 vPos; // read from vertex shader output

uniform float iTime; 
uniform  vec2 uCenter; 
uniform float uScale; 
uniform float uAspect; 

// the function at hand 
vec2 f(vec2 z, vec2 z0);
vec2 cmul(vec2 u, vec2 v);
vec2 complexSin(vec2 z);
vec2 complexCos(vec2 z);

float norm(vec2 z); 
vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// retraction onto the circle radius*S^1
vec2 to_S1(vec2 pt, float t, float radius, float epsilon) {

  float norm = length(norm(pt)) + epsilon; 
  float target_x = radius * pt.x / norm; 
  float target_y = radius * pt.y / norm;

  return vec2(
      (1.0 - t) * pt.x + t * target_x,
      (1.0 - t) * pt.y + t * target_y
  );
}


void main() {

  float t = 1.0 *  (1.0 + sin(iTime)) / 2.0; 

  // pour afficher temporellement 
  // int MAX_ITERS = min(int(iTime) * 100, 1000); 
  int MAX_ITERS = 100;

  // computing mandlebrot "color"
  float x = (vPos.x +uCenter.x) * uScale * uAspect; 
  float y = (vPos.y +uCenter.y )* uScale;

  vec2 z0 = vec2(x, y);
  z0 = to_S1(z0, t, 0.5, 0.0000001);
  // z0 = (1.0 / iTime) * z0;

  vec2 z_next = vec2(0.0); 

  int iteration = 0;
  while(iteration < MAX_ITERS && dot(z_next, z_next) <= 4.0) {
    z_next = f(z_next, z0); 
    iteration = iteration + 1;
  }

  if (iteration >= MAX_ITERS){
    FragColor = vec4(0.0, 0.0, 0.0, 1.0); 
  }
  else {

    float mag = length(z_next);
    mag = max(mag, 1e-8);
    float intensity = float(iteration) / float(MAX_ITERS);

    float mu = float(iteration) + 1.0 - log2(log(mag)); 
    mu = clamp(mu / float(MAX_ITERS), 0, 1.0);

    intensity = 30 * pow(intensity, 0.7);
    float h = fract(0.95 + 10.0 * intensity);
    float s = 0.85;
    float v = 1.0; 

    FragColor = vec4(hsv2rgb(vec3(h, s, v)), 1.0);
    FragColor = vec4(pow(cos(intensity), 2.0), pow(sin(intensity), 2.0), 1.0 - intensity, 1.0);

  }
}

float norm(vec2 z) {
  return z.x * z.x + z.y * z.y;
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

vec2 f(vec2 z, vec2 z0) {
  float a = z.x; 
  float b = z.y; 

  // z^2 = (a + ib) (a + ib) 
  //    = a^2 + 2iab - b^2 
  //    = (a^2 - b^2) + i(2 ab )
  vec2 res = cmul(z, z) + z0;
  return vec2(res.x + z0.x, res.y + z0.y);
  // return vec2(a*a - b*b + z0.x, 2*a*b + z0.y);
}
