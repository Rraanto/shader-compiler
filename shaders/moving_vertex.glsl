#version 460 core 
layout (location = 0) in vec3 pos_in;
out vec2 vPos; // export to be usasble in the fragment 

uniform float iTime;

float norm_2(vec2 pt) {
  // euclidian norm with a safeguard epsilon safeguard
  float epsilon = 0.1; 
  return epsilon + pt.x * pt.x + pt.y * pt.y;
}

vec2 rotate(vec2 pos, vec2 center, float theta);

// continuously deform square to circle
vec2 to_S1(vec2 pt, float t); 

void main()
{
  float rotation_speed = 0.1;
  float theta = 2 * 3.14 * iTime * rotation_speed;
  float t = sin(iTime); 

  vec2 new_pos_xy = to_S1(vec2(pos_in.x, pos_in.y), t);

  // return
  gl_Position = vec4 (new_pos_xy, pos_in.z, 1.0);
  vPos = new_pos_xy;
}

vec2 rotate(vec2 pos, vec2 center, float theta) {
  // rotates (pox.x, pos.y) around center = (a, b) by an angle theta
  // cos(theta) -sin(theta)
  // sin(theta) cos(theta)
  float a = center.x;
  float b = center.y;
  float t_x = cos(theta) * (pos.x - a) - sin(theta) * (pos.y - b) + a; 
  float t_y = sin(theta) * (pos.x - a) + cos(theta) * (pos.y - b) + b;
  return vec2 (t_x, t_y);
}

vec2 to_S1(vec2 pt, float t) {

  float norm = norm_2(pt); 
  float target_x = pt.x / norm; 
  float target_y = pt.y / norm;

  return vec2(
      t * pt.x + (1-t) * target_x,
      t * pt.y + (1-t) * target_y
  );
}
