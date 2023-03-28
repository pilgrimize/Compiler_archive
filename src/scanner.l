%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include "parser.h"
    // #include "stack.h"
    // #include "tools.h"
%}

t_program "program"
t_const "const"
t_var "var"
t_array "array"
t_of "of"
t_integer "integer"
t_real "real"
t_boolean "boolean"
t_char "char"
t_while "while"
t_else "else"
t_procedure "procedure"
t_function "function"
t_begin "begin"
t_end "end"
t_if "if"
t_then "then"
t_for "for"
t_to "to"
t_downto "downto"
t_do "do"
t_read "read"
t_write "write"
t_true "true"
t_false "false"
t_dot ".."
t_repeat "repeat"
t_until "until"
t_case "case"

or_op "or"
addop '+'|'-'
mulop "*"|"/"|"div"|"mod"|"and"
relop "<"|">"|"<>"|"<="|">="
notop "not"
quateop "'"
equalop "="
assignop ":="
blank [ \t\n]
seperator [;(),:.\[\]]
letter [a-zA-Z]
digit [0-9]
digits ({digit})+
optional_fraction "."{digits}
num ({digits}{optional_fraction})|{digits}
literal {quateop}({letter}|{digit})*{quateop} // to be modified
id {letter}({letter}|{digit})*
comment \{[^}]*\}

%%

{num}           {std::cerr << "num:" << yytext << std::endl; 
                yylval.num = (char*)malloc(strlen(yytext)+1);
                strcpy(yylval.num,yytext); 
                return num;
                }
{seperator}     {std::cerr << "seperator:" << yytext << std::endl;  return yytext[0];}
{equalop}       {std::cerr << "equalop:" << yytext << std::endl;  return yytext[0];}
{notop}         {std::cerr << "notop:" << yytext << std::endl;  return notop;}
{quateop}       {std::cerr << "quateop:" << yytext << std::endl;  return yytext[0];}
{addop}         {std::cerr << "addop:" << yytext << std::endl;  return yytext[0];}
{or_op}         {std::cerr << "or_op:" << yytext << std::endl;  return or_op;}
{mulop}         {std::cerr << "mulop:" << yytext << std::endl;  return mulop;}
{relop}         {std::cerr << "relop:" << yytext << std::endl;  return relop;}
{assignop}      {std::cerr << "assignop:" << yytext << std::endl;  return assignop;}
{blank}         {std::cerr << "blank:" << yytext << std::endl;}

{t_program}     {std::cerr << "t_program:" << yytext << std::endl;  return t_program;}
{t_const}       {std::cerr << "t_const:" << yytext << std::endl;  return t_const;}
{t_var}         {std::cerr << "t_var:" << yytext << std::endl;  return t_var;}
{t_array}       {std::cerr << "t_array:" << yytext << std::endl;  return t_array;}
{t_of}          {std::cerr << "t_of:" << yytext << std::endl;  return t_of;}
{t_integer}     {std::cerr << "t_integer:" << yytext << std::endl;  return t_integer;}
{t_real}        {std::cerr << "t_real:" << yytext << std::endl;  return t_real;}
{t_boolean}     {std::cerr << "t_boolean:" << yytext << std::endl;  return t_boolean;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl;  return t_char;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl;  return t_while;}
{t_else}        {std::cerr << "t_else:" << yytext << std::endl;  return t_else;}
{t_procedure}   {std::cerr << "t_procedure:" << yytext << std::endl;  return t_procedure;}
{t_function}    {std::cerr << "t_function:" << yytext << std::endl;  return t_function;}

{t_begin}       {std::cerr << "t_begin:" << yytext << std::endl;  return t_begin;}
{t_end}         {std::cerr << "t_end:" << yytext << std::endl;  return t_end;}
{t_if}          {std::cerr << "t_if:" << yytext << std::endl;  return t_if;}
{t_then}        {std::cerr << "t_then:" << yytext << std::endl;  return t_then;}
{t_for}         {std::cerr << "t_for:" << yytext << std::endl;  return t_for;}
{t_to}          {std::cerr << "t_to:" << yytext << std::endl;  return t_to;}
{t_do}          {std::cerr << "t_do:" << yytext << std::endl;  return t_do;}

{t_dot}         {std::cerr << "t_dot:" << yytext << std::endl;  return t_dot;}
{t_downto}      {std::cerr << "t_downto:" << yytext << std::endl;  return t_downto;}
{t_repeat}      {std::cerr << "t_repeat:" << yytext << std::endl;  return t_repeat;}
{t_until}       {std::cerr << "t_until:" << yytext << std::endl;  return t_until;}
{t_case}        {std::cerr << "t_case:" << yytext << std::endl;  return t_case;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl;  return t_while;}
{t_read}       {std::cerr << "t_read:" << yytext << std::endl;  return t_read;}
{t_write}       {std::cerr << "t_write:" << yytext << std::endl;  return t_write;}


{comment}         {std::cerr << "comment:" << yytext << std::endl; /* do nothing */}
{id}            {std::cerr << "id:" << yytext << std::endl; 
                yylval.str = (char*)malloc(strlen(yytext)+1);
                strcpy(yylval.str,yytext); 
                }

%%
// {literal}       {std::cerr << "literal:" << yytext << std::endl;  return literal;}