/*
 * This library defines
 * a container for shader source codes
 * including the source text as string, and the path
 */

#ifndef SHADER_SOURCE_H
#define SHADER_SOURCE_H

#include <string>

struct ShaderSource {
private:
  std::string _source; // the source content
  std::string _path;
  bool _is_processed; // true when source has been processed

public:
  std::string _processed_source; // the processed source content
  /*
   * It is best that shader source classes are instanciated
   * directly from paths
   * whether they are relative or absolute paths should be checked here
   */
  ShaderSource(const std::string &path);

  void process();

  std::string get_source();

  std::string get_path();
};

#endif
