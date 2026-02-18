#include "preprocessor.h"
#include "loader.h"

Preprocessor::Output
Preprocessor::_expand(const std::filesystem::path &file_path) {
  // Placeholder code for now: doesn't do actual expanding and just loads the
  // file

  std::string source = load_shader_source_from_file(file_path);

  return Preprocessor::Output{true, source, ""};
}

// public
Preprocessor::Output
Preprocessor::process_source(const std::filesystem::path &file_path) {
  // simply wraps to the private expander
  return this->_expand(file_path);
}
