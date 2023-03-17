#include "stack.h"

namespace stack {

std::stack<tree::Tree> ast_stack;

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

}