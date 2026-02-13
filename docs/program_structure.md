# Program structure 
This is an overview of how the program is structured. 

The goal is to have a 2D scene to render shaders with a basic "camera" that we can move in 2 axis.

In `main.cpp` a single rectangle filling the whole viewport constructed from three vertices (3 pairs of `float`) is defined to serve as the drawing space, rendered on a window. 
``
`Camera`, defined in the `camera` library stores informations about a basic camera which roughly allows the rendering of a scene:
- `float _center_x, _center_y`: The point of the plane towards which the camera is pointed at (center);
- `float _scale`: The scale of the scene: roughly the abstract-to-apparent ratio, where abstract refers to the space where mathematical operations are made. A segment $[A, B]$ of length `L` = $||B - A||$ will have an apparent length of ` L / _scale`. 
- `float _zoom_factor`: A float defining how "zoomed-in" the scene is. In practice, it makes the `_scale` value when zooming in or out, mimimum and maximum values for `_zoom_factor` are `_min_zoom_factor`, `_max_zoom_factor`

# Shader compilation pipeline 
Normally, defining shaders single self-contained source files and compiling them once with `openGL` would be enough, but it does not allow for separating sources in different files, defining shader "libraries" to be reused later, ... so there is a preprocessor that handles `#includes` and enforces some rules, so a preprocessing step is included: 
- source `main.glsl` is loaded, eventually including other files: `#include "libary1.glsl"; #include "libary2.glsl;`
- the source is processed into a `main_final.glsl` including all the libraries 
- the processed `main_final.glsl` is sent to the `openGL` compiler. 
