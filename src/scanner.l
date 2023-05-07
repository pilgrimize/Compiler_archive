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
bool_value "true"|"false"
t_dot ".."
t_repeat "repeat"
t_until "until"
t_case "case"
t_writeln "writeln"
t_readln "readln"
t_single "single"
t_double "double"
t_shortint "shortint"
t_longint "longint"
t_byte "byte"
t_string "string"

or_op "or"
addop "+"
subop "-"
mulop "*"|"/"|"div"|"mod"|"and"
relop "<"|">"|"<>"|"<="|">="
notop "not"
literal_char {quateop}({letter}|{digit}|{others}){quateop}
literal_string {quateop}({letter}|{digit}|{others})*{quateop} 
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
double_value {digits}{optional_fraction}
others "@"|"#"|"$"|"%"|"^"|"&"|"*"|"-"|"+"|"="|"|"|"["|"]"|"{"|"}"|";"|":"|","|"<"|">"|"/"|"?"|"~"|" "
id {letter}({letter}|{digit})*
comment \{[^}]*\}

%%

{num}           {std::cerr << "num:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_INT,yytext ));
                return num;
                }
{double_value}    {std::cerr << "double_value:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE_VALUE ,yytext ));
                return double_value;
                }
{bool_value}   {std::cerr << "bool_value:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_BOOL ,yytext ));
                return bool_value;
                }
{literal_char} {std::cerr << "literal_char:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_CHAR ,yytext ));
                return literal_char;
                }
{literal_string} {std::cerr << "literal_string:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_STRING ,yytext ));
                return literal_string;
                }
{leftparen}     {std::cerr << "leftparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTPAREN,yytext )); return leftparen;}
{rightparen}    {std::cerr << "rightparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTPAREN,yytext)); return rightparen;}
{leftbracket}   {std::cerr << "leftbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTBRACKET,yytext )); return leftbracket;}
{rightbracket}  {std::cerr << "rightbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTBRACKET,yytext )); return rightbracket;}
{semicolon}     {std::cerr << "semicolon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEMICOLON,yytext )); return semicolon;}
{comma}         {std::cerr << "comma:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COMMA,yytext )); return comma;}
{colon}         {std::cerr << "colon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COLON,yytext )); return colon;}
{dot}           {std::cerr << "dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::DOT,yytext )); return dot;}

{equalop}       {std::cerr << "equalop:" << yytext << std::endl;  yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext )); return equalop;}
{notop}         {std::cerr << "notop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_NOTOP,yytext )); return notop;}
{quateop}       {std::cerr << "quateop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext )); return quateop;}
{addop}         {std::cerr << "addop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ADDOP,yytext )); return addop;}
{subop}         {std::cerr << "subop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SUBOP,yytext )); return addop;}
{or_op}         {std::cerr << "or_op:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OR_OP,yytext )); return or_op;}
{mulop}         {std::cerr << "mulop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_MULOP,yytext )); return mulop;}
{relop}         {std::cerr << "relop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RELOP,yytext )); return relop;}
{assignop}      {std::cerr << "assignop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ASSIGNOP,yytext )); return assignop;}
{blank}         {std::cerr << "blank:" << yytext << std::endl;}

{t_program}     {std::cerr << "t_program:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROGRAM,yytext )); return t_program;}
{t_const}       {std::cerr << "t_const:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CONST,yytext )); return t_const;}
{t_var}         {std::cerr << "t_var:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_VAR,yytext )); return t_var;}
{t_array}       {std::cerr << "t_array:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ARRAY,yytext )); return t_array;}
{t_of}          {std::cerr << "t_of:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OF,yytext )); return t_of;}
{t_integer}     {std::cerr << "t_integer:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_INTEGER,yytext )); return t_integer;}
{t_real}        {std::cerr << "t_real:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REAL,yytext )); return t_real;}
{t_boolean}     {std::cerr << "t_boolean:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BOOLEAN,yytext )); return t_boolean;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext )); return t_char;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext )); return t_while;}
{t_else}        {std::cerr << "t_else:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ELSE,yytext )); return t_else;}
{t_procedure}   {std::cerr << "t_procedure:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROCEDURE,yytext )); return t_procedure;}
{t_function}    {std::cerr << "t_function:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FUNCTION,yytext )); return t_function;}
{t_writeln}     {std::cerr << "t_writeln:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITELN,yytext )); return t_writeln;}
{t_readln}     {std::cerr << "t_readln:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READLN,yytext )); return t_readln;}
{t_double}    {std::cerr << "t_double:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE,yytext )); return t_double;}
{t_single}      {std::cerr << "t_single:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SINGLE,yytext )); return t_single;}
{t_longint}     {std::cerr << "t_longint:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LONGINT,yytext )); return t_longint;}
{t_byte}        {std::cerr << "t_byte:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BYTE,yytext )); return t_byte;}
{t_shortint}    {std::cerr << "t_shortint:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SHORTINT,yytext )); return t_shortint;}
{t_string}      {std::cerr << "t_string:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_STRING,yytext )); return t_string;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext )); return t_char;}

{t_begin}       {std::cerr << "t_begin:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BEGIN,yytext )); return t_begin;}
{t_end}         {std::cerr << "t_end:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_END,yytext )); return t_end;}
{t_if}          {std::cerr << "t_if:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_IF,yytext )); return t_if;}
{t_then}        {std::cerr << "t_then:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_THEN,yytext )); return t_then;}
{t_for}         {std::cerr << "t_for:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FOR,yytext )); return t_for;}
{t_to}          {std::cerr << "t_to:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_TO,yytext )); return t_to;}
{t_do}          {std::cerr << "t_do:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DO,yytext )); return t_do;}

{t_dot}         {std::cerr << "t_dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOT,yytext )); return t_dot;}
{t_downto}      {std::cerr << "t_downto:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOWNTO,yytext )); return t_downto;}
{t_repeat}      {std::cerr << "t_repeat:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REPEAT,yytext )); return t_repeat;}
{t_until}       {std::cerr << "t_until:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_UNTIL,yytext )); return t_until;}
{t_case}        {std::cerr << "t_case:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CASE,yytext )); return t_case;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext )); return t_while;}
{t_read}       {std::cerr << "t_read:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READ,yytext )); return t_read;}
{t_write}       {std::cerr << "t_write:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITE,yytext )); return t_write;}

{comment}         {std::cerr << "comment:" << yytext << std::endl; /* do nothing */}
{id}            {std::cerr << "id:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ID,yytext ));
                return id;
                }

%%
// {literal}       {std::cerr << "literal:" << yytext << std::endl;  return literal;}
// {seperator}     {std::cerr << "seperator:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEPERATOR,yytext )); return yytext[0];}