#ifndef PASCALS_TO_C_TREE_H
#define PASCALS_TO_C_TREE_H

#include <string>
#include <utility>
#include <vector>
#include <memory>
#include <map>
#include "symbol.h"

namespace tree {

// TODO: add more tokens
enum PID{
    programstruct__programhead_semicolon__programbody_dot,
    program_head__t_program__id_leftparen__idlist__rightparen,
    program_head__t_program__id,
    program_body__const_declarations__var_declarations__subprogram_declarations__compound_statement,
    program_body__const_declarations__var_declarations__compound_statement,
    program_body__const_declarations__subprogram_declarations__compound_statement,
    program_body__var_declarations__subprogram_declarations__compound_statement,
    program_body__const_declarations__compound_statement,
    program_body__var_declarations__compound_statement,
    program_body__subprogram_declarations__compound_statement,
    program_body__compound_statement,
    idlist__id,
    idlist__idlist__comma__id,
    const_declarations__t_const__const_declaration__semicolon,
    const_declaration__id__equalop__const_value,
    const_declaration__const_declaration__semicolon__id__equalop__const_value,
    const_value__num,
    const_value__addop__num,
    const_value__subop__num,
    const_value__literal,
    var_declarations__t_var__var_declaration__semicolon,
    var_declaration__idlist__colon__type,
    var_declaration__var_declaration__semicolon__idlist__colon__type,
    type__basic_type,
    type__t_array__leftbracket__period__rightbracket__t_of__basic_type,
    basic_type__t_integer,
    basic_type__t_real,
    basic_type__t_boolean,
    period__num__t_dot__num,
    period__period__comma__num__t_dot__num,
    subprogram_declarations__subprogram__semicolon,
    subprogram_declarations__subprogram_declarations__subprogram__semicolon,
    subprogram__subprogram_head__semicolon__subprogram_body,
    subprogram_head__t_function__id__formal_parameter__colon__basic_type,
    subprogram_head__t_procedure__id__formal_parameter,
    subprogram_head__t_function__id__colon__basic_type,
    subprogram_head__t_procedure__id,
    formal_parameter__leftparen__parameter_list__rightparen,
    parameter_list__parameter,
    parameter_list__parameter_list__semicolon__parameter,
    parameter__var_parameter,
    parameter__value_parameter,
    var_parameter__t_var__value_parameter,
    value_parameter__idlist__colon__basic_type,
    subprogram_body__compound_statement,
    subprogram_body__const_declarations__compound_statement,
    subprogram_body__var_declarations__compound_statement,
    subprogram_body__const_declarations__var_declarations__compound_statement,
    compound_statement__t_begin__statement_list__t_end,
    compound_statement__t_begin__t_end,
    statement_list__statement_list__semicolon__statement,
    statement__variable__assignop__expression,
    statement__procedure_call,
    statement__compound_statement,
    statement__t_if__expression__t_then__statement,
    statement__t_if__expression__t_then__statement__else_part,
    t_while__expression__t_do__statement,
    statement__t_for__id__assignop__expression__t_downto__expression__t_do__compound_statement,
    statement__t_for__id__assignop__expression__t_to__expression__t_do__compound_statement,
    statement__t_repeat__compound_statement__t_until__expression,
    t_while__expression__t_do__compound_statement,
    statement__t_repeat__statement__t_until__expression,
    statement__t_if__expression__t_then__compound_statement__else_part,
    statement__t_if__expression__t_then__compound_statement,
    statement__t_repeat__statement_list__t_until__expression,
    statement__t_for__id__assignop__expression__t_to__expression__t_do__statement,
    statement__t_for__id__assignop__expression__t_downto__expression__t_do__statement,
    statement__t_read__leftparen__variable_list__rightparen,
    statement__t_write__leftparen__expression_list__rightparen,
    variable_list__variable,
    variable_list__variable_list__comma__variable,
    variable__id,
    variable__id__id_varpart,
    id_varpart__leftbracket__expression_list__rightbracket,
    procedure_call__id__leftparen__expression_list__rightparen,
    procedure_call__id,
    else_part__t_else__statement,
    else_part__t_else,
    expression_list__expression_list__comma__expression,
    expression_list__expression,
    expression__simple_expression,
    expression__simple_expression__relop__simple_expression,
    expression__simple_expression__equalop__simple_expression,
    simple_expression__term,
    simple_expression__term__addop__term,
    simple_expression__term__subop__term,
    simple_expression__term__or_op__term,
    term__factor,
    term__term__mulop__factor,
    factor__leftparen__expression__rightparen,
    factor__variable,
    factor__id__leftparen__expression_list__rightparen,
    factor__num,
    factor__notop__factor,
    factor__subop__factor,
    factor__double_value,
    simple_expression__literal_string,
    simple_expression__literal_char,
    statement__t_readln__leftparen__variable_list__rightparen,
    statement__t_writeln__leftparen__expression_list__rightparen,
    factor__bool_value,
    basic_type__t_char,
    basic_type__t_string,
    basic_type__t_byte,
    basic_type__t_longint,
    basic_type__t_single,
    basic_type__t_double

};
enum Token {
    T_ERROR = -1,
    T_ID,
    T_NUM,
    T_LITERAL_INT,
    T_DOUBLE_VALUE,
    T_DOUBLE,
    T_LITERAL_CHAR,
    T_LITERAL_BOOL,
    T_LITERAL_STRING,
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
    T_VAR_PARAMETER,

    T_LEFTPAREN,
    T_RIGHTPAREN,
    T_LEFTBRACKET,
    T_RIGHTBRACKET,
    T_SEMICOLON,
    T_COMMA,
    T_COLON,
    DOT,
    T_SUBOP,
    T_WRITELN,
    T_READLN,
    T_LONGINT,
    T_SHORTINT,
    T_BYTE,
    T_SINGLE,
    T_STRING,
    T_TRUE,
    T_FALSE,

};


class TreeNode {
private:
    int pid{};
    Token token = T_ERROR;
    std::string text;  // for ID and Literal, empty for others
    std::vector<TreeNode*> children;
    symbol::BasicType type = symbol::TYPE_NULL;
public:
    TreeNode() = default;
    TreeNode(int pid, Token token, std::string text, std::vector<TreeNode*> children = {}) :
            pid(pid), token(token), text(std::move(text)), children(std::move(children)) {}

    Token get_token() const { return token; }
    std::string get_text() const { return text; }
    TreeNode* get_child(int child_id) const { return children.at(child_id); }
    std::vector<TreeNode*>& get_children() { return children; }
    symbol::BasicType get_type() const { return type; }
    void set_type(symbol::BasicType type) { this->type = type; }
    int get_pid() const { return pid; }
    auto children_begin() { return children.begin(); }
    auto children_end() { return children.end(); }
    void childrenPush(TreeNode* x) { children.push_back(x); }
    void set_pid(int x) { pid = x; }
    TreeNode* get_child_by_token(Token child_token) const;
};

class Tree {
private:
    TreeNode* root;
public:
    Tree() = default;
    explicit Tree(TreeNode* root) :
         root(root) {}

    TreeNode* get_root() const { return root; }
};

extern Tree* ast;

// Convert CST to AST, should always return true given a valid CST
bool cst_to_ast(const Tree& cst);

}

typedef tree::Tree *TypeTree;


#endif //PASCALS_TO_C_TREE_H