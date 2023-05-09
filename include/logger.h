#ifndef PASCALS_TO_C_LOGGER_H
#define PASCALS_TO_C_LOGGER_H

#include <fstream>
#include "tree.h"

namespace logger {

enum LogLevel {
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    FATAL,
};

static std::ofstream output_stream;
static std::ofstream log_stream;
static LogLevel log_level;

void set_logger(const std::string& output_file, const std::string& log_file, LogLevel _log_level);

void output(const std::string& message, bool new_line = false);

void log(const std::string& message, int line_number = -1, LogLevel level = ERROR);

void log(const std::string& message, tree::Position position, LogLevel level= ERROR);

}

#endif //PASCALS_TO_C_LOGGER_H
