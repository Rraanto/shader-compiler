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

vec2 comp_exp(vec2 z) {
  // complex exponential exp(z)
  float a = exp(z.x) * cos(z.y);
  float b = exp(z.y) * sin(z.y);
  return vec2(a, b);
}
