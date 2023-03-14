%{
    #include <iostream>
    int yylex();
    void yyerror(char *s);
%}

%start E
%token num
%type E T F

%%

/* descriptions of productions */

E: E '+' T { std::cout << "Use production: E -> E + T" << std::endl; }
    | E '-' T { std::cout << "Use production: E -> E - T" << std::endl; }
    | T { std::cout << "Use production: E -> T" << std::endl; }
    ;

T: T '*' F { std::cout << "Use production: T -> T * F" << std::endl; }
    | T '/' F { std::cout << "Use production: T -> T / F" << std::endl; }
    | F { std::cout << "Use production: T -> F" << std::endl; }
    ;

F: '(' E ')' { std::cout << "Use production: F -> (E)" << std::endl; }
    | num { std::cout << "Use production: F -> num" << std::endl; }
    ;

%%

void yyerror(char *s) {
    std::cerr << "Error: " << std::string(s) << std::endl;
}