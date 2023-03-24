#include "stack.h"
#include "tools.h"
#include <iostream>

namespace stack {

std::stack<tree::Tree> ast_stack;
std::vector<tree::Tree> temp_stack;

void push_tree(tree::Tree tree) {
    ast_stack.push(tree);
}

void push_token(tree::Token token, const std::string& text) {
    ast_stack.emplace(std::make_shared<tree::TreeNode>(token, text));
}

void reduce(int production_length, tree::Token token, const std::string& text) {
    std::vector<std::shared_ptr<tree::TreeNode>> children;
    for (int i = 0; i < production_length; i++) {
        children.push_back(ast_stack.top().get_root());
        ast_stack.pop();
    }
    ast_stack.emplace(std::make_shared<tree::TreeNode>(token, text, children));
}

void push_error() {
    ast_stack.emplace(std::make_shared<tree::TreeNode>(tree::Token::T_ERROR, ""));
}

void clear_error() {
    while (ast_stack.top().get_root()->get_token() != tree::Token::T_ERROR) {
        ast_stack.pop();
    }
    ast_stack.pop();
}

void push_temp(int production_length) {
    temp_stack.clear();
    for (int i = 0; i < production_length; i++) {
        temp_stack.push_back(ast_stack.top());
        ast_stack.pop();
    }
}

void print_ast_stack(){
    std::cout << "AST stack:" << std::endl;
    std::stack<tree::Tree> temp_stack;
    while (!ast_stack.empty()) {
        temp_stack.push(ast_stack.top());
        ast_stack.pop();
    }
    while (!temp_stack.empty()) {
        std::cout << tools::turn_token_text(temp_stack.top().get_root()->get_token()) << std::endl;
        ast_stack.push(temp_stack.top());
        temp_stack.pop();
    }
}

}