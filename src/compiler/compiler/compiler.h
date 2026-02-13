/*
 * defines the Compiler class that wraps for glfw compiler
 */

#ifndef COMPILER_H
#define COMPILER_H

#include <GL/gl.h>
#include <filesystem>
#include <vector>
#include "preprocessor/preprocessor.h"

typedef enum CompileResult { SUCCESS, ERROR } CompileResult;

struct Compiler {
  Preprocessor _preprocessor; // a preprocessor attached

  Compiler(const std::vector<std::filesystem::path> &include_dirs)
      : _preprocessor(Preprocessor(include_dirs)) {}

  /*
   * Compiles the shader source to the openGL unsigned int out
   */
  CompileResult compile(const ShaderSource &source, const GLuint &out);
};

#endif
