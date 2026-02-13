#version 460 core

#define SPHERE_SIZE 0.5
#define EPSILON 0.000001

out vec4 FragColor;

in vec2 vPos; // read from vertex shader output

uniform float iTime; 

float function(float x, float y, float factor); 
vec3 heatmap(float t, float inf, float sup);
float norm_2(vec2 pt); // euclidian norm with epsilon safeguard
vec2 to_S1(vec2 pt, float t); // continuous deform R^2\0 to S^1
vec3 colors_grid(vec2 pt, float spacing, float thickness); // allows to draw a grid 
vec2 rotate(vec2 pos, vec2 center, float theta);

vec2 retract_borders(vec2 pt, float t); // retract everything except middle vertical line 
                                         // to the sides 

void main()
{
  // scale factor 
  float factor = 10.0; 
  // float t = (1.0 + sin(iTime)) / 2.0; // t oscillates betweebetween to 1 
  float t = (1.0 + sin(iTime * 0.4));

  // distort continuously to S^1 when t = 1
  vec2 new_pos = (norm_2(vPos) > EPSILON)? to_S1(vPos, t) : vec2(vPos.x, vPos.y);

  // Rotate at angle * 2 * 3.14 * iTime
  new_pos = rotate(new_pos, vec2(0.0, 0.0), 0.2* 3.14 * iTime);

  // retraction onto the sides
  new_pos = retract_borders(new_pos, t);

  // for grid 
  float spacing = 0.05; 
  float thickness = 0.01;
  vec3 grid_color_at = colors_grid(vec2(new_pos.x, new_pos.y), spacing, thickness);

  FragColor = vec4(grid_color_at, 1.0);
}


float function(float x, float y, float factor){
  // factor corresponds to the scale  of transformation
  // sin(||x, y||^2)
  // scaled so outputs actual wave
  y = y * factor;
  x = x * factor;
  return sin(x) * sin(y); 
}

vec3 heatmap(float t, float inf, float sup){
  // is a heatmap for t 
  // : blue when t minimum, red when maximum 
  float u = (t - inf) / (sup - inf);
  return vec3(u, sin(3.14 * u), 1-u);
}

float norm_2(vec2 pt) {
  // euclidian norm with a safeguard epsilon
  float epsilon = EPSILON; 
  return epsilon + pt.x * pt.x + pt.y * pt.y;
}

vec2 to_S1(vec2 pt, float t) {

  float norm = norm_2(pt); 
  float target_x = SPHERE_SIZE * pt.x / norm; 
  float target_y = SPHERE_SIZE * pt.y / norm;

  return vec2(
      (1.0 - t) * pt.x + t * target_x,
      (1.0 - t) * pt.y + t * target_y
  );
}

vec3 colors_grid(vec2 pt, float spacing, float thickness) {
  vec2 g = mod(pt, spacing);

  // nearest grid line 
  float d = min(
    min(g.x, spacing - g.x),
    min(g.y, spacing - g.y)
  );

  float line = step(d, thickness);

  vec3 fg = vec3(0.1);
  vec3 bg = vec3(1.0);

  return vec3(mix(bg, fg, line));
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

vec2 retract_borders(vec2 pt, float t) {
  float x = pt.x; float y = pt.y; 
  if (x == 0.0) {
    return pt; 
  } else {
    return vec2(
      (1.0 - t) * x + sign(x)*t,
      y
    );
  }
}


