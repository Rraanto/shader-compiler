#include "loader.h"

#include <cerrno>
#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>

#include <iostream>
#include <string>

std::string load_shader_source_from_file(const std::string &filename) {
  /* loads shader source from file
   *
   * purely input-output: no validity checks are made
   */
  std::ifstream f(filename);
  if (!f.is_open()) {
    std::cerr << "Failed to load shader source: " << filename
              << " (errno=" << errno << ", " << std::strerror(errno) << ")\n";
    return "";
  }

  std::stringstream buffer;
  buffer << f.rdbuf();

  const std::string source = buffer.str();

  if (source.empty()) {
    std::cerr << "Shader source file is empty: " << filename << "\n";
  }

  return source;
}

GLuint compile_shader(GLenum type, const char *source, const char *label) {
  /*
   * Compiles shader into GLuint
   *
   * @parameter type: the type of the shader
   * char* source: the source
   * char* label: developper-set label to call the shader that is being compiled
   */

  GLuint shader = glCreateShader(type);
  if (shader == 0) {
    std::cerr << "glCreateShader returned 0 for " << label << " shader\n";
    return 0;
  }

  if (source == nullptr) {
    std::cerr << "Null shader source passed to " << label << "shader\n";
    glDeleteShader(shader);
    return 0;
  }

  glShaderSource(shader, 1, &source, nullptr);
  glCompileShader(shader);

  int success = 0;
  char info_log[512] = {1};
  glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

  if (!success) {
    glGetShaderInfoLog(shader, 512, nullptr, info_log);

    std::cerr << "ERROR::SHADER::" << label << "::COMPILATION_FAILED\n"
              << info_log << "\n";
    glDeleteShader(shader);
    return 0;
  }

  return shader;
}
