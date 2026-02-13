# Some technical notes 
This contains some notes on specific development parts. 

## Defining a uniform in glsl 
Uniforms are used to "transfer" data from the main program to the shader programs, practically it allows using variables like time, camera center, mouse pointer location ... in the shader sources. 

They are defined in the shader sources by: 
```
uniform <type> <variable_name>; 
```
- `<type>` must be one of the standard GLSL types (`vec2`, `float`, `mat4`, ...)

- `<variable_name>` is an arbitrary variable name

Then they are bound to a value from the cpu program: 
```C++
glUseProgram(shader_program)
...
GLint loc = glGetUniformLocation(shader_program, "<variable_name>");
glUniform<amount>f(loc, ...(<amount> number of variables) ....); 
```
- `shader_program` must be a shader program using the shader source where a uniform variable has been declared 
- `<variable_name>` must match the name that has been declared in the shader source
- `<amount>` is an integer that specifies the number of fields of the `<type>` of the uniform declared in the shader source file, for a `vec2` uniform, the syntax is: `glUniform2f(loc, a, b)`
