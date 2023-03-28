%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include "parser.h"
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
addop '+'
subop '-'
mulop "*"|"/"|"div"|"mod"|"and"
relop "<"|">"|"<>"|"<="|">="
notop "not"
quateop "'"
equalop "="
assignop ":="
blank [ \t\n]
leftparen  "(" 
rightparen ")"
leftbracket "["
rightbracket "]"
semicolon ";"
comma ","
colon ":"
dot "."
letter [a-zA-Z]
digit [0-9]
digits ({digit})+
optional_fraction "."{digits}
num {digits}
float_num {digits}{optional_fraction}
literal {quateop}({letter}|{digit})*{quateop} 
id {letter}({letter}|{digit})*
comment \{[^}]*\}

%%

{num}           {std::cerr << "num:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_NUM,yytext )); 
                return num;
                }
{leftparen}     {std::cerr << "leftparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_LEFTPAREN,"" )); return leftparen;}
{rightparen}    {std::cerr << "rightparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_RIGHTPAREN,"" )); return rightparen;}
{leftbracket}   {std::cerr << "leftbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_LEFTBRACKET,"" )); return leftbracket;}
{rightbracket}  {std::cerr << "rightbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_RIGHTBRACKET,"" )); return rightbracket;}
{semicolon}     {std::cerr << "semicolon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_SEMICOLON,"" )); return semicolon;}
{comma}         {std::cerr << "comma:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_COMMA,"" )); return comma;}
{colon}         {std::cerr << "colon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_COLON,"" )); return colon;}
{dot}           {std::cerr << "dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::DOT,"" )); return dot;}

{equalop}       {std::cerr << "equalop:" << yytext << std::endl;  yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_QUATEOP,"" )); return equalop;}
{notop}         {std::cerr << "notop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_NOTOP,"" )); return notop;}
{quateop}       {std::cerr << "quateop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_QUATEOP,"" )); return quateop;}
{addop}         {std::cerr << "addop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_ADDOP,"" )); return addop;}
{subop}         {std::cerr << "subop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_SUBOP,"" )); return addop;}
{or_op}         {std::cerr << "or_op:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_OR_OP,"" )); return or_op;}
{mulop}         {std::cerr << "mulop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_MULOP,"" )); return mulop;}
{relop}         {std::cerr << "relop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_RELOP,"" )); return relop;}
{assignop}      {std::cerr << "assignop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_ASSIGNOP,"" )); return assignop;}
{blank}         {std::cerr << "blank:" << yytext << std::endl;}

{t_program}     {std::cerr << "t_program:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_PROGRAM,"" )); return t_program;}
{t_const}       {std::cerr << "t_const:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_CONST,"" )); return t_const;}
{t_var}         {std::cerr << "t_var:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_VAR,"" )); return t_var;}
{t_array}       {std::cerr << "t_array:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_ARRAY,"" )); return t_array;}
{t_of}          {std::cerr << "t_of:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_OF,"" )); return t_of;}
{t_integer}     {std::cerr << "t_integer:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_INTEGER,"" )); return t_integer;}
{t_real}        {std::cerr << "t_real:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_REAL,"" )); return t_real;}
{t_boolean}     {std::cerr << "t_boolean:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_BOOLEAN,"" )); return t_boolean;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_CHAR,"" )); return t_char;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_WHILE,"" )); return t_while;}
{t_else}        {std::cerr << "t_else:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_ELSE,"" )); return t_else;}
{t_procedure}   {std::cerr << "t_procedure:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_PROCEDURE,"" )); return t_procedure;}
{t_function}    {std::cerr << "t_function:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_FUNCTION,"" )); return t_function;}

{t_begin}       {std::cerr << "t_begin:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_BEGIN,"" )); return t_begin;}
{t_end}         {std::cerr << "t_end:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_END,"" )); return t_end;}
{t_if}          {std::cerr << "t_if:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_IF,"" )); return t_if;}
{t_then}        {std::cerr << "t_then:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_THEN,"" )); return t_then;}
{t_for}         {std::cerr << "t_for:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_FOR,"" )); return t_for;}
{t_to}          {std::cerr << "t_to:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_TO,"" )); return t_to;}
{t_do}          {std::cerr << "t_do:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_DO,"" )); return t_do;}

{t_dot}         {std::cerr << "t_dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_DOT,"" )); return t_dot;}
{t_downto}      {std::cerr << "t_downto:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_DOWNTO,"" )); return t_downto;}
{t_repeat}      {std::cerr << "t_repeat:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_REPEAT,"" )); return t_repeat;}
{t_until}       {std::cerr << "t_until:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_UNTIL,"" )); return t_until;}
{t_case}        {std::cerr << "t_case:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_CASE,"" )); return t_case;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_WHILE,"" )); return t_while;}
{t_read}       {std::cerr << "t_read:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_READ,"" )); return t_read;}
{t_write}       {std::cerr << "t_write:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_WRITE,"" )); return t_write;}

{literal}      {std::cerr << "literal:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_LITERAL,"" )); return literal;}

{comment}         {std::cerr << "comment:" << yytext << std::endl; /* do nothing */}
{id}            {std::cerr << "id:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_ID,yytext )); 
                return id;
                }

%%
// {literal}       {std::cerr << "literal:" << yytext << std::endl;  return literal;}
// {seperator}     {std::cerr << "seperator:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(0,tree::T_SEPERATOR,"" )); return yytext[0];}