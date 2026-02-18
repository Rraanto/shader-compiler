SThis is a hobby project implementing a shader compiler/visualiser. 

The goal is to have a self-contained local tool to "play" with shaders without much fuss.

The program **Has not been tested** at all.

Current main work: 
- Writing a specific preprocessor for shader sources: a preprocessor is needed to allow defining "libraries" such as `complex.glsl` and include them in the main, user written shader, or allow user to write libraries themselves, which is really a code cleanliness issue. The current "preprocessor" does nothing and `Preprocessor` is a dummy class that just holds structure 

- Make an UI that allows loading and/or editing shader sources in real time implying that multiple shaders compilations per session should be allowed
