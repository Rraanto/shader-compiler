This is a hobby project implementing a shader compiler/visualiser. 

The goal is to have a self-contained local tool to "play" with shaders without much fuss.

The program **Has not been tested** at all.

Main work: 
- Minimal preprocessing of the shader sources to allow for non-circular `#include "..."` directives and dispatching shader source code over many libraries. Adding more static analysis during that preprocessing phase might help since the openGL compiler will tell error info about the preprocessed code (line number) and tiny mistakes in shader source code can be tedious to spot. 

