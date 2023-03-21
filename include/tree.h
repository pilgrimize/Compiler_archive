#ifndef PASCALS_TO_C_TREE_H
#define PASCALS_TO_C_TREE_H

#include <string>
#include <utility>
#include <vector>
#include <memory>
#include <map>

namespace tree {

// TODO: add more tokens
enum Token {
    T_ERROR = -1,
    T_ID,
    T_NUM,
    T_RELOP,
	T_SEPERATOR,
	T_ADDOP,
	T_NOTES,
	T_MULOP,
	T_ASSIGNOP,
	T_RESVERVE_WORD
};

class TreeNode {
private:
    Token token = T_ERROR;
    std::string text;  // for ID and Literal, empty for others
    std::vector<std::shared_ptr<TreeNode>> children;
public:
    TreeNode() = default;
    TreeNode(Token token, std::string text, std::vector<std::shared_ptr<TreeNode>> children = {}) :
            token(token), text(std::move(text)), children(std::move(children)) {}

    Token get_token() const { return token; }
    std::string get_text() const { return text; }
    std::vector<std::shared_ptr<TreeNode>> get_children() const { return children; }
};

class Tree {
private:
    std::shared_ptr<TreeNode> root;
public:
    Tree() = default;
    explicit Tree(std::shared_ptr<TreeNode> root) : root(std::move(root)) {}

    std::shared_ptr<TreeNode> get_root() const { return root; }
};

extern Tree ast;

// Convert CST to AST, should always return true given a valid CST
bool cst_to_ast(const Tree& cst);

}

#endif //PASCALS_TO_C_TREE_H