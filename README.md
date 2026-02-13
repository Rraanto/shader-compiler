This is a hobby project implementing a shader compiler/visualiser. 

The goal is to have a self-contained local tool to "play" with shaders without much fuss.

The program **Has not been tested** at all.

Main work: 
- Writing a specific preprocessor for shader sources: a preprocessor is needed to allow defining "libraries" such as `complex.glsl` and include them in the main, user written shader, or allow user to write libraries themselves, which is really a code cleanliness issue. The current (temporary) method launches subprocesses to process the `glsl` source files with `clang`, which is wrong for so many reasons, including that it does a lot for just wanting an `#include` feature.

- Wrap everything in the `compiler` libary (unused for now, will replace `loader`) 
