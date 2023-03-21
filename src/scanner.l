%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include "parser.h"
    #include "stack.h"
%}

reserve_word "program"|"const"|"var"|"array"|"of"|"integer"|"real"|"boolean"|"char"|"while"|"else"|"not"|"procedure"|"function"|"begin"|"end"|"if"|"then"|"for"|"to"|"do"|"read"|"write"
addop "+"|"-"|"or"
mulop "*"|"/"|"div"|"mod"|"and"
relop "<"|">"|"="|"<>"|"<="|">="
assignop ":="
blank [ \t\n]
seperator [;(),:.\[\]]
letter [a-zA-Z]
digit [0-9]
digits ({digit})+
optional_fraction "."{digits}
num ({digits}{optional_fraction})|{digits}
notes [\{]([^\}])*[\}]
id {letter}({letter}|{digit})*

%%

{num}           {std::cerr << "num:" << yytext << std::endl; stack::push_token(tree::T_NUM, yytext); return num;}
{seperator}     {std::cerr << "seperator:" << yytext << std::endl; stack::push_token(tree::T_SEPERATOR); return yytext[0];}
{addop}         {std::cerr << "addop:" << yytext << std::endl; stack::push_token(tree::T_ADDOP, yytext); return addop;}
{mulop}         {std::cerr << "mulop:" << yytext << std::endl; stack::push_token(tree::T_MULOP, yytext); return mulop;}
{relop}         {std::cerr << "relop:" << yytext << std::endl; stack::push_token(tree::T_RELOP, yytext); return relop;}
{assignop}      {std::cerr << "assignop:" << yytext << std::endl; stack::push_token(tree::T_ASSIGNOP, yytext); return assignop;}
{reserve_word}  {std::cerr << "reserve_word:" << yytext << std::endl; stack::push_token(tree::T_RESVERVE_WORD, yytext); return reserve_word;}
{notes}         {std::cerr << "notes:" << yytext << std::endl; stack::push_token(tree::T_NOTES, yytext); return notes;}
{id}            {std::cerr << "id:" << yytext << std::endl; stack::push_token(tree::T_ID, yytext); return id;}

%%
