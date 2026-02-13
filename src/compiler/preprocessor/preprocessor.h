/*
 * This defines preprocessor wrapper struct
 * AND
 * a wrapper for analysis outputs (NOT YET IMPLEMENTED)
 */

#ifndef PREPROCESSOR_H
#define PREPROCESSOR_H

#include <filesystem>
#include <string>
#include <vector>

#include "shader_source/shader_source.h"

typedef enum PreprocessResult { SUCCESS, ERROR } PreprocessResult;

struct Preprocessor {
  std::vector<std::filesystem::path>
      _include_dirs; // directories in which to look for includes

  Preprocessor(const std::vector<std::filesystem::path> &include_dirs)
      : _include_dirs(include_dirs) {}

  PreprocessorResult process(const ShaderSource &shader_source);
};

#endif
