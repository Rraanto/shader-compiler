/*
 * helper library to load shaders
 * and compile them
 */

#ifndef LOADER_H
#define LOADER_H

#include <glad/glad.h>
#include <iostream>
#include <string>

/* loads shader source from file
 *
 * purely input-output: no validity checks are made
 */
std::string load_shader_source_from_file(const std::string &filename);

/*
 * Compiles shader into GLuint
 *
 * @parameter type: the type of the shader
 * char* source: the source
 * char* label: developper-set label to call the shader that is being compiled
 */
GLuint compile_shader(GLenum type, const char *source, const char *label);

#endif
