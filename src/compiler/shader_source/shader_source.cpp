#include "shader_source.h"
#include <string>

void ShaderSource::process() { this->_is_processed = true; }

std::string ShaderSource::get_source() { return this->_source; }

std::string ShaderSource::get_path() { return this->_path; }
