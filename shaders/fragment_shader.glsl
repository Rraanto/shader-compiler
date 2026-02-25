#version 460 core

#include "mandlebrot_utils.glsl"

out vec4 FragColor; // color output 
in vec2 vPos; // read from vertex shader output

// uniforms 
uniform vec2 uCenter;
uniform float uScale; 
uniform float uAspect; // aspect ratio 
uniform float uTime; 

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

  FragColor = vec4(color_per_point(position, max_iters), 1.0);
}

