#ifndef PASCALS_TO_C_STACK_H
#define PASCALS_TO_C_STACK_H

#include <string>
#include <stack>

#include "tree.h"

namespace stack {

extern std::stack<tree::Tree> ast_stack;

void push_token(tree::Token token, const std::string& text = "");

void reduce(int production_length, tree::Token token, const std::string& text = "");

void push_error();

void clear_error();

}


#endif //PASCALS_TO_C_STACK_H