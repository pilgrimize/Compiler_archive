%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include "parser.h"
    // typedef struct YYLTYPE YYLTYPE;
    // struct YYLTYPE
    // {
    //     int first_line;
    //     int first_column;
    //     int last_line;
    //     int last_column;
    // };
    // extern YYLTYPE yylloc; /* 用于定位的，在yacc中提供，需要声明为extern*/
    // static void update_loc() /* 用于定位的行列的，每次在识别一个成分之前会调用*/
    // {
    //     static int curr_line = 1;/*静态变量*/
    //     static int curr_col  = 1;
    //     yylloc.first_line   = curr_line;
    //     yylloc.first_column = curr_col;
    //     {
    //         char * s; 
    //         for(s = yytext; *s != '\0'; s++) /*yytext是取到词的数组的开始地址*/
    //         {
    //             if(*s == '\n'){/*是换行符行数+1*/
    //             curr_line++;
    //             curr_col = 1;
    //             }
    //             else{
    //             curr_col++;
    //             }
    //         }
    //     }
    //     yylloc.last_line   = curr_line;
    //     yylloc.last_column = curr_col-1;
    // }

    // #define YY_USER_ACTION update_loc();
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
id ({letter}|"_")({letter}|{digit}|"_")*
comment \{[^}]*\}

%%

{num}           {std::cerr << "num:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_INT,yytext ,yylineno));
                return num;
                }
{double_value}    {std::cerr << "double_value:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE_VALUE ,yytext ,yylineno ));
                return double_value;
                }
{bool_value}   {std::cerr << "bool_value:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_BOOL ,yytext ,yylineno ));
                return bool_value;
                }
{literal_char} {std::cerr << "literal_char:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_CHAR ,yytext ,yylineno ));
                return literal_char;
                }
{literal_string} {std::cerr << "literal_string:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_STRING ,yytext ,yylineno ));
                return literal_string;
                }
{leftparen}     {std::cerr << "leftparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTPAREN,yytext ,yylineno )); return leftparen;}
{rightparen}    {std::cerr << "rightparen:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTPAREN,yytext ,yylineno)); return rightparen;}
{leftbracket}   {std::cerr << "leftbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTBRACKET,yytext ,yylineno )); return leftbracket;}
{rightbracket}  {std::cerr << "rightbracket:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTBRACKET,yytext ,yylineno )); return rightbracket;}
{semicolon}     {std::cerr << "semicolon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEMICOLON,yytext ,yylineno )); return semicolon;}
{comma}         {std::cerr << "comma:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COMMA,yytext ,yylineno )); return comma;}
{colon}         {std::cerr << "colon:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COLON,yytext ,yylineno )); return colon;}
{dot}           {std::cerr << "dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::DOT,yytext ,yylineno )); return dot;}

{equalop}       {std::cerr << "equalop:" << yytext << std::endl;  yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,yylineno )); return equalop;}
{notop}         {std::cerr << "notop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_NOTOP,yytext ,yylineno )); return notop;}
{quateop}       {std::cerr << "quateop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,yylineno )); return quateop;}
{addop}         {std::cerr << "addop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ADDOP,yytext ,yylineno )); return addop;}
{subop}         {std::cerr << "subop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SUBOP,yytext ,yylineno )); return addop;}
{or_op}         {std::cerr << "or_op:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OR_OP,yytext ,yylineno )); return or_op;}
{mulop}         {std::cerr << "mulop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_MULOP,yytext ,yylineno )); return mulop;}
{relop}         {std::cerr << "relop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RELOP,yytext ,yylineno )); return relop;}
{assignop}      {std::cerr << "assignop:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ASSIGNOP,yytext ,yylineno )); return assignop;}
{blank}         {std::cerr << "blank:" << yytext << std::endl;}

{t_program}     {std::cerr << "t_program:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROGRAM,yytext ,yylineno )); return t_program;}
{t_const}       {std::cerr << "t_const:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CONST,yytext ,yylineno )); return t_const;}
{t_var}         {std::cerr << "t_var:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_VAR,yytext ,yylineno )); return t_var;}
{t_array}       {std::cerr << "t_array:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ARRAY,yytext ,yylineno )); return t_array;}
{t_of}          {std::cerr << "t_of:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OF,yytext ,yylineno )); return t_of;}
{t_integer}     {std::cerr << "t_integer:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_INTEGER,yytext ,yylineno )); return t_integer;}
{t_real}        {std::cerr << "t_real:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REAL,yytext ,yylineno )); return t_real;}
{t_boolean}     {std::cerr << "t_boolean:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BOOLEAN,yytext ,yylineno )); return t_boolean;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext ,yylineno )); return t_char;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext ,yylineno )); return t_while;}
{t_else}        {std::cerr << "t_else:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ELSE,yytext ,yylineno )); return t_else;}
{t_procedure}   {std::cerr << "t_procedure:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROCEDURE,yytext ,yylineno )); return t_procedure;}
{t_function}    {std::cerr << "t_function:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FUNCTION,yytext ,yylineno )); return t_function;}
{t_writeln}     {std::cerr << "t_writeln:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITELN,yytext ,yylineno )); return t_writeln;}
{t_readln}     {std::cerr << "t_readln:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READLN,yytext ,yylineno )); return t_readln;}
{t_double}    {std::cerr << "t_double:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE,yytext ,yylineno )); return t_double;}
{t_single}      {std::cerr << "t_single:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SINGLE,yytext ,yylineno )); return t_single;}
{t_longint}     {std::cerr << "t_longint:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LONGINT,yytext ,yylineno )); return t_longint;}
{t_byte}        {std::cerr << "t_byte:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BYTE,yytext ,yylineno )); return t_byte;}
{t_shortint}    {std::cerr << "t_shortint:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SHORTINT,yytext ,yylineno )); return t_shortint;}
{t_string}      {std::cerr << "t_string:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_STRING,yytext ,yylineno )); return t_string;}
{t_char}        {std::cerr << "t_char:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext ,yylineno )); return t_char;}

{t_begin}       {std::cerr << "t_begin:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BEGIN,yytext ,yylineno )); return t_begin;}
{t_end}         {std::cerr << "t_end:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_END,yytext ,yylineno )); return t_end;}
{t_if}          {std::cerr << "t_if:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_IF,yytext ,yylineno )); return t_if;}
{t_then}        {std::cerr << "t_then:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_THEN,yytext ,yylineno )); return t_then;}
{t_for}         {std::cerr << "t_for:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FOR,yytext ,yylineno )); return t_for;}
{t_to}          {std::cerr << "t_to:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_TO,yytext ,yylineno )); return t_to;}
{t_do}          {std::cerr << "t_do:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DO,yytext ,yylineno )); return t_do;}

{t_dot}         {std::cerr << "t_dot:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOT,yytext ,yylineno )); return t_dot;}
{t_downto}      {std::cerr << "t_downto:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOWNTO,yytext ,yylineno )); return t_downto;}
{t_repeat}      {std::cerr << "t_repeat:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REPEAT,yytext ,yylineno )); return t_repeat;}
{t_until}       {std::cerr << "t_until:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_UNTIL,yytext ,yylineno )); return t_until;}
{t_case}        {std::cerr << "t_case:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CASE,yytext ,yylineno )); return t_case;}
{t_while}       {std::cerr << "t_while:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext ,yylineno )); return t_while;}
{t_read}       {std::cerr << "t_read:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READ,yytext ,yylineno )); return t_read;}
{t_write}       {std::cerr << "t_write:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITE,yytext ,yylineno )); return t_write;}

{comment}         {std::cerr << "comment:" << yytext << std::endl; /* do nothing */}
{id}            {std::cerr << "id:" << yytext << std::endl; 
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ID,yytext ,yylineno ));
                return id;
                }

%%
// {literal}       {std::cerr << "literal:" << yytext << std::endl;  return literal;}
// {seperator}     {std::cerr << "seperator:" << yytext << std::endl; yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEPERATOR,yytext ,yylineno )); return yytext[0];}