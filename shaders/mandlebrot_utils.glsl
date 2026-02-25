#include "complex.glsl"
#include "colorutils.glsl"

// the main dynamical system to study 
vec2 f(vec2 z, vec2 z0) {
  return cmul(z, z) + z0;
}

vec3 color_per_point(vec2 z0, int max_iters)
// coloring each point in terms of the dynamical system f above
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
