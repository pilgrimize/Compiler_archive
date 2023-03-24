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
	T_OR_OP,
    T_QUATEOP,
    T_ADDOP,
	T_MULOP,
	T_ASSIGNOP,
	T_KEYWORD,
    T_PROGRAM_STRUCT,
    T_PROGRAM_HEAD,
    T_PROGRAM_BODY,
    T_CONST_DECLARATIONS,
    T_CONST_DECLARATION,
    T_CONST_VALUE,
    T_VAR_DECLARATIONS,
    T_VAR_DECLARATION,
    T_COMPOUND_STATEMENT,
    T_TYPE,
    T_BASIC_TYPE,
    T_PERIOD,
    T_FORMAL_PARAMETER,
    T_PARAMETER_LIST,
    T_PARAMETER,
    T_VALUE_PARAMETER,
    T_VARIABLE_LIST,
    T_ID_VARPART,
    T_EXPRESSION_LIST,
    T_PROCEDURE_CALL,
    T_ELSE_PART,
    T_SUBPROGRAM,
    T_SUBPROGRAM_DECLARATIONS,
    T_SUBPROGRAM_DECLARATION,
    T_SUBPROGRAM_HEAD,
    T_SUBPROGRAM_BODY,
    T_ARGUMENTS,
    T_STATEMENT_LIST,
    T_STATEMENT,
    T_VARIABLE,
    T_EXPRESSION,
    T_SIMPLE_EXPRESSION,
    T_TERM,
    T_EQUALOP,
    T_FACTOR,
    T_LITERAL,
    T_NOTOP,

    T_PROGRAM,
    T_CONST,
    T_VAR,
    T_PROCEDURE,
    T_FUNCTION,
    T_BEGIN,
    T_END,
    T_IF,
    T_THEN,
    T_ELSE,
    T_WHILE,
    T_DO,
    T_FOR,
    T_TO,
    T_DOT,
    T_DOWNTO,
    T_REPEAT,
    T_UNTIL,
    T_CASE,
    T_READ,
    T_WRITE,
    T_BOOLEAN,
    T_INTEGER,
    T_CHAR,
    T_REAL,
    T_OF,
    T_ARRAY,
    T_IDLIST,
    T_VAR_PARAMETER
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