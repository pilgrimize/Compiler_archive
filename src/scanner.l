%option noyywrap

%{
    #include "parser.h"
%}

%%

[0-9]+                 { return num; }
[ \t\n]                ;
[+-/()]|"*"           { return yytext[0]; }

%%