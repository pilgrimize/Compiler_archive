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
    leaf_pid,
    programstruct__T__programhead_semicolon__programbody_dot,
    program_head__T__t_program__id_leftparen__idlist__rightparen,
    program_head__T__t_program__id,
    program_body__T__const_declarations__var_declarations__subprogram_declarations__compound_statement,
    program_body__T__const_declarations__var_declarations__compound_statement,
    program_body__T__const_declarations__subprogram_declarations__compound_statement,
    program_body__T__var_declarations__subprogram_declarations__compound_statement,
    program_body__T__const_declarations__compound_statement,
    program_body__T__var_declarations__compound_statement,
    program_body__T__subprogram_declarations__compound_statement,
    program_body__T__compound_statement,
    idlist__T__id,
    idlist__T__idlist__comma__id,
    const_declarations__T__t_const__const_declaration__semicolon,
    const_declaration__T__id__equalop__const_value,
    const_declaration__T__const_declaration__semicolon__id__equalop__const_value,
    const_value__T__num,
    const_value__T__addop__num,
    const_value__T__subop__num,
    const_value__T__literal_string,
    var_declarations__T__t_var__var_declaration__semicolon,
    var_declaration__T__idlist__colon__type,
    var_declaration__T__var_declaration__semicolon__idlist__colon__type,
    type__T__basic_type,
    type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type,
    basic_type__T__t_integer,
    basic_type__T__t_real,
    basic_type__T__t_boolean,
    period__T__num__t_dot__num,
    period__T__period__comma__num__t_dot__num,
    subprogram_declarations__T__subprogram__semicolon,
    subprogram_declarations__T__subprogram_declarations__subprogram__semicolon,
    subprogram__T__subprogram_head__semicolon__subprogram_body,
    subprogram_head__T__t_function__id__formal_parameter__colon__basic_type,
    subprogram_head__T__t_procedure__id__formal_parameter,
    subprogram_head__T__t_function__id__colon__basic_type,
    subprogram_head__T__t_procedure__id,
    formal_parameter__T__leftparen__parameter_list__rightparen,
    parameter_list__T__parameter,
    parameter_list__T__parameter_list__semicolon__parameter,
    parameter__T__var_parameter,
    parameter__T__value_parameter,
    var_parameter__T__t_var__value_parameter,
    value_parameter__T__idlist__colon__basic_type,
    subprogram_body__T__compound_statement,
    subprogram_body__T__const_declarations__compound_statement,
    subprogram_body__T__var_declarations__compound_statement,
    subprogram_body__T__const_declarations__var_declarations__compound_statement,
    compound_statement__T__t_begin__statement_list__t_end,
    compound_statement__T__t_begin__t_end,
    statement_list__T__statement,
    statement_list__T__statement_list__semicolon__statement,
    statement__T__variable__assignop__expression,
    statement__T__procedure_call,
    statement__T__compound_statement,
    statement__T__t_if__expression__t_then__statement,
    statement__T__t_if__expression__t_then__statement__else_part,
    statement__T__t_while__T__expression__t_do__statement,
    statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__compound_statement,
    statement__T__t_for__id__assignop__expression__t_to__expression__t_do__compound_statement,
    statement__T__t_repeat__statement__t_until__expression,
    statement__T__t_repeat__statement_list__t_until__expression,
    statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement,
    statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__statement,
    statement__T__t_read__leftparen__variable_list__rightparen,
    statement__T__t_write__leftparen__expression_list__rightparen,
    variable_list__T__variable,
    variable_list__T__variable_list__comma__variable,
    variable__T__id,
    variable__T__id__id_varpart,
    id_varpart__T__leftbracket__expression_list__rightbracket,
    procedure_call__T__id__leftparen__expression_list__rightparen,
    procedure_call__T__id,
    else_part__T__t_else__statement,
    else_part__T__t_else,
    expression_list__T__expression_list__comma__expression,
    expression_list__T__expression,
    expression__T__simple_expression,
    expression__T__simple_expression__relop__simple_expression,
    expression__T__simple_expression__equalop__simple_expression,
    simple_expression__T__term,
    simple_expression__T__term__addop__term,
    simple_expression__T__term__subop__term,
    simple_expression__T__term__or_op__term,
    term__T__factor,
    term__T__term__mulop__factor,
    factor__T__leftparen__expression__rightparen,
    factor__T__variable,
    factor__T__id__leftparen__expression_list__rightparen,
    factor__T__num,
    factor__T__notop__factor,
    factor__T__subop__factor,
    factor__T__double_value,
    simple_expression__T__literal_string,
    simple_expression__T__literal_char,
    statement__T__t_readln__leftparen__variable_list__rightparen,
    statement__T__t_writeln__leftparen__expression_list__rightparen,
    factor__T__bool_value,
    basic_type__T__t_char,
    basic_type__T__t_string,
    basic_type__T__t_byte,
    basic_type__T__t_longint,
    basic_type__T__t_single,
    basic_type__T__t_double,
    const_value__T__addop__double_value,
    const_value__T__subop__double_value,
    const_value__T__double_value,
    factor__T__id__leftparen__rightparen,
    const_value__T__literal_char,
    procedure_call__T__id__leftparen__rightparen,
    formal_parameter__T__leftparen__rightparen

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

struct Position{
    int first_line;
    int first_column;
    int last_line;
    int last_column;
};

class TreeNode {
private:
    PID pid{};
    Token token = T_ERROR;
    std::string text;  // for ID and Literal, empty for others
    std::vector<TreeNode*> children;
    symbol::BasicType type = symbol::TYPE_NULL;
    Position position;
    std::vector<std::string> comments;
public:
    TreeNode() = default;
    TreeNode(PID pid, Token token, std::string text, Position position, std::vector<std::string> comments={} , std::vector<TreeNode*> children = {}) :
            pid(pid), token(token), text(std::move(text)), position(position), comments(std::move(comments)), children(std::move(children)) {}

    Token get_token() const { return token; }
    int get_line() const {return position.first_line; }
    Position get_position() const { return position; }
    std::string get_text() const { return text; }
    TreeNode* get_child(int child_id) const { return children.at(child_id); }
    std::vector<TreeNode*>& get_children() { return children; }
    symbol::BasicType get_type() const { return type; }
    void set_type(symbol::BasicType type) { this->type = type; }
    PID get_pid() const { return pid; }
    auto children_begin() { return children.begin(); }
    auto children_end() { return children.end(); }
    void childrenPush(TreeNode* x) { children.push_back(x); }
    void set_pid(PID x) { pid = x; }
    TreeNode* get_child_by_token(Token child_token) const;

    std::vector<std::string> get_comments() const { return comments; }
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