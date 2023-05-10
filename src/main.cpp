#include <iostream>
#include <getopt.h>
#include "parser.h"
#include "semantic.h"
#include "generate.h"
#include "tools.h"
#include "logger.h"

using namespace logger;

int IsYaccError = 0;
int DoGenerate = 0;

bool lex_yacc() {
    if (!yyparse()) {
        tools::print_ast(tree::ast->get_root());
        log("Lexical and syntactic analysis passed.", -1, INFO);
        return true;
    } else {
        log("Failed at lexical or syntactic analysis, abort.", -1, FATAL);
        return false;
    }
}

bool semantic_analysis() {
    if (semantic::semantic_analysis()) {
        log("Semantic analysis passed.", -1, INFO);
        return true;
    } else {
        log("Failed at semantic analysis, abort.", -1, FATAL);
        return false;
    }
}

bool code_generation() {
    if (generate::generate_code()) {
        log("Code generation passed.", -1, INFO);
        return true;
    } else {
        log("Failed at code generation, abort.", -1, FATAL);
        return false;
    }
}

int parse_args(int argc, char *argv[]) {
    std::string input_file, output_file, log_file;
    LogLevel log_level = INFO;
    int c;
    while (true) {
        static struct option long_options[] = {
            {"help", no_argument, nullptr, 'h'},
            {"debug", no_argument, nullptr, 'd'},
            {"input", required_argument, nullptr, 'i'},
            {"output", required_argument, nullptr, 'o'},
            {"log", required_argument, nullptr, 'l'},
            {nullptr, 0, nullptr, 0}
        };
        int option_index = 0;
        c = getopt_long(argc, argv, "dhi:o:l:", long_options, &option_index);
        if (c == -1) {
            break;
        }
        switch (c) {
            case 'h':
                std::cerr << "Usage: " << argv[0] << " [options]" << std::endl;
                std::cerr << "Options:" << std::endl;
                std::cerr << "  -h, --help\t\t\tShow this help message and exit" << std::endl;
                std::cerr << "  -d, --debug\t\t\tEnable debug mode" << std::endl;
                std::cerr << "  -i, --input <file>\t\tSpecify input file" << std::endl;
                std::cerr << "  -o, --output <file>\t\tSpecify output file" << std::endl;
                std::cerr << "  -l, --log <file>\t\tSpecify log file" << std::endl;
                exit(0);
            case 'd':
                log_level = DEBUG;
                break;
            case 'i':
                input_file = optarg;
                break;
            case 'o':
                output_file = optarg;
                break;
            case 'l':
                log_file = optarg;
                break;
            default:
                std::cout << "Usage: " << argv[0] << " [-h] [-d] [-i <file>] [-o <file>] [-l <file>]" << std::endl;
                exit(0);
        }
    }

    if (!input_file.empty()) {
        std::freopen(input_file.c_str(), "r", stdin);
    }
    set_logger(output_file, log_file, log_level);

    if (lex_yacc() && (!IsYaccError) && semantic_analysis() && code_generation()) {
        log("Compilation passed.", -1, INFO);
        return 0;
    } else {
        log("Compilation failed.", -1, FATAL);
        return 1;
    }
}

int main(int argc, char *argv[]) {
    return parse_args(argc, argv);
}