#ifndef PASCLAS_TO_C_TOOLS_H
#define PASCLAS_TO_C_TOOLS_H

#include<string>
#include "tree.h"
#include <iostream>

namespace tools{
    int convertStringToNumber(std::string str);
    std::string intToString(int num);
    std::string turn_token_text(tree::Token token);
    tree::Tree* reduce(std::initializer_list<tree::Tree*> list, int pid, tree::Token token);
    void print_ast(tree::TreeNode* x);
    void destroy_ast(tree::TreeNode* x);
}

#endif //PASCLAS_TO_C_TOOLS_H