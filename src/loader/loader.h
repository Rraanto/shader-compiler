#ifndef LOADER_H
#define LOADER_H

#include <filesystem>
#include <string>

/*
 * Loads source from a file
 *
 * pure input operation: no content processing is done here
 *
 * Returns an empty string if file is not valid
 */
std::string load_shader_source_from_file(const std::filesystem::path &filepath);

#endif
