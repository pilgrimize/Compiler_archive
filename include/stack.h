#ifndef PASCALS_TO_C_STACK_H
#define PASCALS_TO_C_STACK_H

#include <string>
#include <stack>
#include <vector>

#include "tree.h"

namespace stack {

extern std::stack<tree::Tree> ast_stack;

extern std::vector<tree::Tree> temp_stack;

void push_token(tree::Token token, const std::string& text = "");

void push_tree(tree::Tree tree);

void push_temp(int production_length);

void reduce(int production_length, tree::Token token, const std::string& text = "");

void push_error();

void clear_error();

void print_ast_stack();

}


#endif //PASCALS_TO_C_STACK_H