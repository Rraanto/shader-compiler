cmake_minimum_required(VERSION 3.20)

project(ShaderCompiler LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-g -ggdb3 -O0 -fno-omit-frame-pointer)

# external dependencies 
# glfw's own CMakeLists.txt does the job 
# target name is glfw
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # avoid building glfw test exes
set(GLFW_BUILD_TESTS    OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_DOCS     OFF CACHE BOOL "" FORCE)
set(GLFW_INSTALL        OFF CACHE BOOL "" FORCE)
add_subdirectory(external/glfw)

# Glad library
add_library(glad STATIC external/glad/src/glad.c)
target_include_directories(glad
  PUBLIC 
  external/glad/include 
  external/glad/KHR${GLAD_COMPAT_INCLUDE_DIR}
  PRIVATE
  external/glad/include/glad
)

add_library (loader STATIC src/loader/loader.cpp)
target_include_directories(loader PRIVATE src/loader)
target_link_libraries(loader PRIVATE glad)

add_library(camera STATIC src/camera/camera.cpp)
target_include_directories(camera PRIVATE src/camera)

# Main executable 
add_executable(main src/main.cpp)
target_link_libraries(main 
  PRIVATE 
  loader
  camera
  glfw 
  glad

)
target_compile_definitions(main PRIVATE SHADERS_DIR="${CMAKE_CURRENT_SOURCE_DIR}/shaders") # expose to executables to load shaders at runtime
