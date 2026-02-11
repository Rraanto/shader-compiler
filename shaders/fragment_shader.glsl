#version 460 core
out vec4 FragColor;

in vec2 vPos; // read from vertex shader output

uniform float iTime; 

void main() {
  FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
