#include "loader/loader.h"
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <filesystem>

#include <iostream>
#include <string>

static void error_callback(int error, const char *description);

int main() {

  const int WIDTH = 1000, HEIGHT = 800;

  glfwSetErrorCallback(error_callback);

  if (!glfwInit()) {
    std::cerr << "GLFW initialization failed\n";
    return EXIT_FAILURE;
  }

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  GLFWwindow *window =
      glfwCreateWindow(WIDTH, HEIGHT, "Shader run", nullptr, nullptr);

  /*
   * various window checks
   */
  if (!window) {
    std::cerr << "Failed to create GLFW window\n";
    glfwTerminate();
    return EXIT_FAILURE;
  }

  glfwMakeContextCurrent(window);

  if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
    std::cerr << "Failed to initialize GLAD\n";
    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_FAILURE;
  }

  /*
   * Loading and compiling shaders
   */
  std::string v_shader_path =
      (std::filesystem::path(SHADERS_DIR) / "vertex_shader.glsl").string();
  std::string f_shader_path =
      (std::filesystem::path(SHADERS_DIR) / "fragment_shader.glsl").string();
  std::string v_source = load_shader_source_from_file(v_shader_path);
  std::string f_source = load_shader_source_from_file(f_shader_path);

  if (v_source.empty() || f_source.empty()) {
    std::cerr << "Shader source is empty."
              << " vertex_size=" << v_source.size()
              << " fragment_size=" << f_source.size() << "\n";
    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_FAILURE;
  }

  const char *v_shader_source = v_source.c_str();
  const char *f_shader_source = f_source.c_str();

  GLuint vertex_shader =
      compile_shader(GL_VERTEX_SHADER, v_shader_source, "VERTEX");
  if (vertex_shader == 0) {
    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_FAILURE;
  }

  GLuint fragment_shader =
      compile_shader(GL_FRAGMENT_SHADER, f_shader_source, "FRAGMENT");
  if (fragment_shader == 0) {
    glDeleteShader(vertex_shader);
    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_FAILURE;
  }

  GLuint shader_program = glCreateProgram();
  glAttachShader(shader_program, vertex_shader);
  glAttachShader(shader_program, fragment_shader);
  glLinkProgram(shader_program);

  int success = 0;
  char info_log[512] = {0};
  glGetProgramiv(shader_program, GL_LINK_STATUS, &success);
  if (!success) {
    glGetProgramInfoLog(shader_program, 512, nullptr, info_log);
    std::cerr << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << info_log << "\n";
    glDeleteShader(vertex_shader);
    glDeleteShader(fragment_shader);
    glDeleteProgram(shader_program);
    glfwDestroyWindow(window);
    glfwTerminate();
    return EXIT_FAILURE;
  }

  glDeleteShader(vertex_shader);
  glDeleteShader(fragment_shader);

  /*
   * main loop
   */
  while (!glfwWindowShouldClose(window)) {
    int w, h;
    glfwPollEvents();
    glfwGetFramebufferSize(window, &w, &h);
    glViewport(0, 0, w / 2.0, h / 2.0);
    glClearColor(1.0f, 1.0f, 1.0f, 0.1f); // background color;
    glClear(GL_COLOR_BUFFER_BIT);

    glfwSwapBuffers(window);
  }
}

static void error_callback(int error, const char *description) {
  std::cerr << "GLFW error" << error << ": " << description << std::endl;
}
