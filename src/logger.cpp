#include "logger.h"
#include <iostream>

namespace logger {
std::string log_level_to_string(LogLevel level) {
    switch (level) {
    case DEBUG:
        return "DEBUG ";
    case INFO:
        return "INFO ";
    case WARNING:
        return "WARNING ";
    case ERROR:
        return "ERROR ";
    case FATAL:
        return "FATAL ";
    }
}

void set_logger(const std::string& output_file, const std::string& log_file, LogLevel _log_level) {
    if (output_file.empty()) {
        output_stream.basic_ios<char>::rdbuf(std::cout.rdbuf());
    } else {
        output_stream.open(output_file);
    }
    if (log_file.empty()) {
        log_stream.basic_ios<char>::rdbuf(std::cerr.rdbuf());
    } else {
        log_stream.open(log_file);
    }
    log_level = _log_level;
}

void output(const std::string& message, bool new_line) {
    output_stream << message;
    if (new_line) {
        output_stream << std::endl;
    }
}

void log(const std::string& message, int line_number, LogLevel level) {
    if (level >= log_level) {
        log_stream << log_level_to_string(level) << message;
        if (line_number >= 0) {
            log_stream << ": line " << line_number;
        }
        log_stream << std::endl;
    }
}

void log(const std::string& message, tree::Position position, LogLevel level) {
    if (level >= log_level) {
        log_stream << log_level_to_string(level) << message;
        // if (line_number >= 0) {
        log_stream << ": line " << position.first_line<< ", column " << position.first_column;
        // }
        log_stream << std::endl;
    }
}
} // namespace logger