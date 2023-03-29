#include "tree.h"

namespace tree {

Tree* ast;

TreeNode* TreeNode::get_child_by_token(Token child_token) const {
    for (auto child : children) {
        if (child->get_token() == child_token) {
            return child;
        }
    }
    return nullptr;
}

// TODO: implement this function
// Convert CST to AST, should always return true given a valid CST
bool cst_to_ast(const Tree& cst) {
    return true;
}

}