%{
    #include <iostream>
    #include <string.h>
    
    #include "stack.h"

    int yylex();
    extern int yylineno;
    extern char *yytext;
    void yyerror(char *s);
%}

%start E
%token num
%type E T F

%%

/* This is an example of defining productions with error handling */

E: E '+' T { std::cerr << "Use production: E -> E + T" << std::endl; }
    | E '-' T { std::cerr << "Use production: E -> E - T" << std::endl; }
    | T { std::cerr << "Use production: E -> T" << std::endl; }
    | error T { std::cerr << "error on E fixed" << std::endl; yyerrok; }
    ;

T: T '*' F { std::cerr << "Use production: T -> T * F" << std::endl; }
    | T '/' F { std::cerr << "Use production: T -> T / F" << std::endl; }
    | F { std::cerr << "Use production: T -> F" << std::endl; }
    | error F {
        std::cerr << "error on T fixed" << std::endl;
        stack::clear_error();
        stack::push_token(tree::T_NUM, "114514");
        stack::reduce(3, tree::T_NUM);
        yyerrok; /* example */ }
    ;

F: '(' E ')' { std::cerr << "Use production: F -> (E)" << std::endl; }
    | num { std::cerr << "Use production: F -> num" << std::endl; }
    | error num { std::cerr << "error on F fixed" << std::endl; yyerrok; }
    ;

%%

// Error log, should not be modified at present
void yyerror(char *s) {
    stack::push_error();
    if (strlen(yytext) == 0) {
        std::cerr << "Error: " << "end of file: " << "missing operand or block end" << std::endl;
    } else {
        std::cerr << "Error: " << std::string(s) << " at line: " << yylineno << ", encountering unexpected word " << yytext << std::endl;
    }
}