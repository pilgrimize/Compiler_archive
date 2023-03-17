%option noyywrap
%option yylineno

%{
    #include <iostream>
    
    #include "parser.h"
    #include "stack.h"
%}

%%

[0-9]+                 { std::cerr << yytext << std::endl; stack::push_token(tree::T_NUM, yytext); return num; /* example */ }
[ \t\n]                ;
[+-/()]|"*"           { std::cerr << yytext[0] << std::endl; return yytext[0]; }

%%