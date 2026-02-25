#include "loader.h"

#include <iostream>
#include <fstream>
#include <sstream>

std::string load_file_content(const std::filesystem::path &filepath) {

  // using the construction
  std::ifstream file(filepath);
  if (!file.is_open()) {
    std::cerr << "Empty string returned for shader source " << filepath.string()
              << std::endl;
    return "";
  }

  std::ostringstream buffer;
  buffer << file.rdbuf();
  return buffer.str();
}
