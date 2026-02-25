#ifndef LOADER_H
#define LOADER_H

#include <filesystem>
#include <string>

/*
 * Loads the content of a file into a string
 *
 * pure input operation: no content processing is done here
 *
 * Returns an empty string if file is not valid
 */
std::string load_file_content(const std::filesystem::path &filepath);

#endif
