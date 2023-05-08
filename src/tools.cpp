#include <string>
#include <sstream>
#include "tools.h"
#include "logger.h"
using namespace logger;

namespace tools{
    int convertStringToNumber(const std::string& str){
        int num;
        std::stringstream ss;
        ss << str;
        ss >> num;
        return num;
    }
    std::string intToString(int num){
        std::stringstream ss;
        ss << num;
        return ss.str();
    }
    tree::Tree* reduce(std::initializer_list<tree::Tree*> list, int line, tree::PID pid, tree::Token token , std::string text){
        if(text == "") text = turn_token_text(token);
        auto* tnode = new tree::TreeNode(pid, token, text, line);
        tnode->set_pid(pid);
        for (auto it = list.begin(); it != list.end(); ++it) {
            tnode->childrenPush((*it)->get_root());
        }
        return new tree::Tree(tnode);
    }
    
    void print_ast(tree::TreeNode* x) {
        // every time first output x's token then print x's direct children's token and last print x's children respectively
        log(std::string("[present node]")+turn_token_text(x->get_token())+std::string(" , text: ")+x->get_text(), x->get_line(),DEBUG);
        log("[direct children]",-1,DEBUG);
        for (auto it = x->children_begin(); it != x->children_end(); ++it) {
            log( turn_token_text((*it)->get_token())+"   ",-1,DEBUG);
        }
        log("",-1,DEBUG);
        for (auto it = x->children_begin(); it != x->children_end(); ++it) {
            print_ast(*it);
        }
    }

    void destroy_ast(tree::TreeNode* x) {
        for (auto it = x->children_begin(); it != x->children_end(); ++it) {
            destroy_ast(*it);
        }
        delete x;
    }

    std::string turn_token_text(tree::Token token) 
    {
    // give the case each in one line like case tree::T_CASE: return "T_CASE";
        switch (token) {
            case tree::T_ERROR: return "T_ERROR";
            case tree::T_ID: return "T_ID";
            case tree::T_NUM: return "T_NUM";
            case tree::T_RELOP: return "T_RELOP";
            case tree::T_SEPERATOR: return "T_SEPERATOR";
            case tree::T_OR_OP: return "T_OR_OP";
            case tree::T_QUATEOP: return "T_QUATEOP";
            case tree::T_ADDOP: return "T_ADDOP";
            case tree::T_MULOP: return "T_MULOP";
            case tree::T_ASSIGNOP: return "T_ASSIGNOP";
            case tree::T_KEYWORD: return "T_KEYWORD";
            case tree::T_PROGRAM_STRUCT: return "T_PROGRAM_STRUCT";
            case tree::T_PROGRAM_HEAD: return "T_PROGRAM_HEAD";
            case tree::T_PROGRAM_BODY: return "T_PROGRAM_BODY";
            case tree::T_CONST_DECLARATIONS: return "T_CONST_DECLARATIONS";
            case tree::T_CONST_DECLARATION: return "T_CONST_DECLARATION";
            case tree::T_CONST_VALUE: return "T_CONST_VALUE";
            case tree::T_VAR_DECLARATIONS: return "T_VAR_DECLARATIONS";
            case tree::T_VAR_DECLARATION: return "T_VAR_DECLARATION";
            case tree::T_COMPOUND_STATEMENT: return "T_COMPOUND_STATEMENT";
            case tree::T_TYPE: return "T_TYPE";
            case tree::T_BASIC_TYPE: return "T_BASIC_TYPE";
            case tree::T_PERIOD: return "T_PERIOD";
            case tree::T_FORMAL_PARAMETER: return "T_FORMAL_PARAMETER";
            case tree::T_PARAMETER_LIST: return "T_PARAMETER_LIST";
            case tree::T_PARAMETER: return "T_PARAMETER";
            case tree::T_VALUE_PARAMETER: return "T_VALUE_PARAMETER";
            case tree::T_VARIABLE_LIST: return "T_VARIABLE_LIST";
            case tree::T_ID_VARPART: return "T_ID_VARPART";
            case tree::T_EXPRESSION_LIST: return "T_EXPRESSION_LIST";
            case tree::T_PROCEDURE_CALL: return "T_PROCEDURE_CALL";
            case tree::T_ELSE_PART: return "T_ELSE_PART";
            case tree::T_SUBPROGRAM: return "T_SUBPROGRAM";
            case tree::T_SUBPROGRAM_DECLARATIONS: return "T_SUBPROGRAM_DECLARATIONS";
            case tree::T_SUBPROGRAM_DECLARATION: return "T_SUBPROGRAM_DECLARATION";
            case tree::T_SUBPROGRAM_HEAD: return "T_SUBPROGRAM_HEAD";
            case tree::T_SUBPROGRAM_BODY: return "T_SUBPROGRAM_BODY";
            case tree::T_ARGUMENTS: return "T_ARGUMENTS";
            case tree::T_STATEMENT_LIST: return "T_STATEMENT_LIST";
            case tree::T_STATEMENT: return "T_STATEMENT";
            case tree::T_VARIABLE: return "T_VARIABLE";
            case tree::T_EXPRESSION: return "T_EXPRESSION";
            case tree::T_SIMPLE_EXPRESSION: return "T_SIMPLE_EXPRESSION";
            case tree::T_TERM: return "T_TERM";
            case tree::T_EQUALOP: return "T_EQUALOP";
            case tree::T_FACTOR: return "T_FACTOR";
            // case tree::T_LITERAL: return "T_LITERAL";
            case tree::T_NOTOP: return "T_NOTOP";
            case tree::T_PROGRAM: return "T_PROGRAM";
            case tree::T_CONST: return "T_CONST";
            case tree::T_VAR: return "T_VAR";
            case tree::T_PROCEDURE: return "T_PROCEDURE";
            case tree::T_FUNCTION: return "T_FUNCTION";
            case tree::T_BEGIN: return "T_BEGIN";
            case tree::T_END: return "T_END";
            case tree::T_IF: return "T_IF";
            case tree::T_THEN: return "T_THEN";
            case tree::T_ELSE: return "T_ELSE";
            case tree::T_WHILE: return "T_WHILE";
            case tree::T_DO: return "T_DO";
            case tree::T_FOR: return "T_FOR";
            case tree::T_TO: return "T_TO";
            case tree::T_DOT: return "T_DOT";
            case tree::T_DOWNTO: return "T_DOWNTO";
            case tree::T_REPEAT: return "T_REPEAT";
            case tree::T_UNTIL: return "T_UNTIL";
            case tree::T_CASE: return "T_CASE";
            case tree::T_READ: return "T_READ";
            case tree::T_WRITE: return "T_WRITE";
            case tree::T_BOOLEAN: return "T_BOOLEAN";
            case tree::T_INTEGER: return "T_INTEGER";
            case tree::T_CHAR: return "T_CHAR";
            case tree::T_REAL: return "T_REAL";
            case tree::T_OF: return "T_OF";
            case tree::T_ARRAY: return "T_ARRAY";
            case tree::T_IDLIST: return "T_IDLIST";

            case tree::T_LEFTPAREN: return "T_LEFTPAREN";
            case tree::T_RIGHTPAREN: return "T_RIGHTPAREN";
            case tree::T_LEFTBRACKET: return "T_LEFTBRACKET";
            case tree::T_RIGHTBRACKET: return "T_RIGHTBRACKET";
            case tree::T_SEMICOLON: return "T_SEMICOLON";
            case tree::T_COMMA: return "T_COMMA";
            case tree::T_COLON: return "T_COLON";
            case tree::T_SUBOP: return "T_SUBOP";
            case tree::DOT: return "DOT";

            case tree::T_LITERAL_INT: return "T_LITERAL_INT";
            case tree::T_DOUBLE_VALUE: return "T_DOUBLE_VALUE";
            case tree::T_LITERAL_CHAR: return "T_LITERAL_CHAR";
            case tree::T_LITERAL_STRING: return "T_LITERAL_STRING";
            case tree::T_LITERAL_BOOL: return "T_LITERAL_BOOL";
            case tree::T_READLN: return "T_READLN";
            case tree::T_WRITELN: return "T_WRITELN";
            case tree::T_SINGLE: return "T_SINGLE";
            case tree::T_DOUBLE: return "T_DOUBLE";
            case tree::T_BYTE: return "T_BYTE";
            case tree::T_SHORTINT: return "T_SHORTINT";
            case tree::T_LONGINT: return "T_LONGINT";
            case tree::T_STRING: return "T_STRING";
            case tree::T_FALSE: return "T_FALSE";
            case tree::T_TRUE: return "T_TRUE";
            case tree::T_VAR_PARAMETER: return "T_VAR_PARAMETER";
        }
    }
}