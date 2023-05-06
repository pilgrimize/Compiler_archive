#include <iostream>
#include <getopt.h>
#include "parser.h"
#include "semantic.h"
#include "generate.h"
#include "tools.h"

bool lex_yacc() {
    if (!yyparse()) {
        tools::print_ast(tree::ast->get_root());
        std::cerr << "Lexical and syntactic analysis passed." << std::endl;
        return true;
    } else {
        std::cerr << "Fatal error at lexical or syntactic analysis, abort." << std::endl;
        return false;
    }
}

bool semantic_analysis() {
    if (semantic::semantic_analysis()) {
        std::cerr << "Semantic analysis passed." << std::endl;
        return true;
    } else {
        std::cerr << "Fatal error at semantic analysis, abort." << std::endl;
        return false;
    }
}

bool code_generation() {
    if (generate::generate_code()) {
        std::cerr << "Code generation passed." << std::endl;
        return true;
    } else {
        std::cerr << "Fatal error at code generation, abort." << std::endl;
        return false;
    }
}

int parse_args(int argc, char *argv[]) {
    std::string input_file, output_file, log_file;
    int c;
    while (true) {
        static struct option long_options[] = {
            {"help", no_argument, nullptr, 'h'},
            {"input", required_argument, nullptr, 'i'},
            {"output", required_argument, nullptr, 'o'},
            {"log", required_argument, nullptr, 'l'},
            {nullptr, 0, nullptr, 0}
        };
        int option_index = 0;
        c = getopt_long(argc, argv, "hi:o:l:", long_options, &option_index);
        if (c == -1) {
            break;
        }
        switch (c) {
            case 'h':
                std::cerr << "Usage: " << argv[0] << " [options]" << std::endl;
                std::cerr << "Options:" << std::endl;
                std::cerr << "  -h, --help\t\t\tShow this help message and exit" << std::endl;
                std::cerr << "  -i, --input <file>\t\tSpecify input file" << std::endl;
                std::cerr << "  -o, --output <file>\t\tSpecify output file" << std::endl;
                std::cerr << "  -l, --log <file>\t\tSpecify log file" << std::endl;
                exit(0);
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
                std::cout << "Usage: " << argv[0] << " [-h] [-i <file>] [-o <file>] [-l <file>]" << std::endl;
                exit(0);
        }

        if (!input_file.empty()) {
            std::freopen(input_file.c_str(), "r", stdin);
        }
        if (!output_file.empty()) {
            std::freopen(output_file.c_str(), "w", stdout);
        }
        if (!log_file.empty()) {
            std::freopen(log_file.c_str(), "w", stderr);
        }
    }

    if (lex_yacc() && semantic_analysis()) {
        std::cerr << "Compilation passed." << std::endl;
        return 0;
    } else {
        std::cerr << "Compilation failed." << std::endl;
        return 1;
    }
}

int main(int argc, char *argv[]) {
    return parse_args(argc, argv);
}