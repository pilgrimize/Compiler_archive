#include <iostream>
#include <getopt.h>
#include "parser.h"

void parse_args(int argc, char *argv[]) {
    int c;
    while (true) {
        static struct option long_options[] = {
            {"help", no_argument, nullptr, 'h'},
            {nullptr, 0, nullptr, 0}
        };
        int option_index = 0;
        c = getopt_long(argc, argv, "h", long_options, &option_index);
        if (c == -1) {
            break;
        }
        switch (c) {
            case 'h':
                std::cout << "Usage: " << argv[0] << " [options]" << std::endl;
                std::cout << "Options:" << std::endl;
                std::cout << "  -h, --help\t\t\tShow this help message and exit" << std::endl;
                break;
            case '?':
                break;
            default:
                std::cout << "Usage: " << argv[0] << " [-h]" << std::endl;
                break;
        }
    }

    if (yyparse()) {
        std::cout << "Error encountered" << std::endl;
    } else {
        std::cout << "Accepted" << std::endl;
    }
}

int main(int argc, char *argv[]) {
    parse_args(argc, argv);
    return 0;
}