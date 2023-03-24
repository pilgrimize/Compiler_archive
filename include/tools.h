#ifndef PASCLAS_TO_C_TOOLS_H
#define PASCLAS_TO_C_TOOLS_H

#include<string>
#include "tree.h"

namespace tools{
    int convertStringToNumber(std::string str);
    std::string intToString(int num);
    std::string turn_token_text(tree::Token token);
}

#endif //PASCLAS_TO_C_TOOLS_H