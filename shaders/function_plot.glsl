#version 460 core

#define EPS 0.005

out vec4 FragColor;
in vec2 vPos; // read from vertex shader output

uniform float iTime; 
uniform  vec2 uCenter; 
uniform float uScale; 
uniform float uAspect; 

float f(float x); 

void main() {

  vec2 pt = uScale * (uCenter + vPos);

  if (pt.x != 0) {
    if ( abs( f(pt.x) - pt.y )  < EPS) {
      FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
      FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
  }

}

float f(float x) { 
  return cos(x); 
}
