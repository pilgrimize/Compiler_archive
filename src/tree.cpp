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

}