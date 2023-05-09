%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include "parser.h"
    #include "logger.h"
    using namespace logger;
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
quateop "'"
literal_char {quateop}({letter}|{digit}|{others}){quateop}
literal_string {quateop}({letter}|{digit}|{others})*{quateop} 
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
others "@"|"#"|"$"|"%"|"^"|"&"|"*"|"-"|"+"|"="|"|"|"["|"]"|"{"|"}"|";"|":"|","|"<"|">"|"/"|"?"|"~"|" "|"!"|blank
id ({letter}|"_")({letter}|{digit}|"_")*
comment \{[^}]*\}

%%

{num}           {log( std::string( "num:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_INT,yytext ,yylineno));
                return num;
                }
{double_value}    {log( std::string( "double_value:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE_VALUE ,yytext ,yylineno ));
                return double_value;
                }
{bool_value}   {log( std::string( "bool_value:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_BOOL ,yytext ,yylineno ));
                return bool_value;
                }
{literal_char} {log( std::string( "literal_char:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_CHAR ,yytext ,yylineno ));
                return literal_char;
                }
{literal_string} {log( std::string( "literal_string:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_STRING ,yytext ,yylineno ));
                return literal_string;
                }
{leftparen}     {log( std::string( "leftparen:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTPAREN,yytext ,yylineno )); return leftparen;}
{rightparen}    {log( std::string( "rightparen:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTPAREN,yytext ,yylineno)); return rightparen;}
{leftbracket}   {log( std::string( "leftbracket:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTBRACKET,yytext ,yylineno )); return leftbracket;}
{rightbracket}  {log( std::string( "rightbracket:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTBRACKET,yytext ,yylineno )); return rightbracket;}
{semicolon}     {log( std::string( "semicolon:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEMICOLON,yytext ,yylineno )); return semicolon;}
{comma}         {log( std::string( "comma:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COMMA,yytext ,yylineno )); return comma;}
{colon}         {log( std::string( "colon:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COLON,yytext ,yylineno )); return colon;}
{dot}           {log( std::string( "dot:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::DOT,yytext ,yylineno )); return dot;}

{equalop}       {log( std::string( "equalop:") + yytext , yylineno, DEBUG); yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,yylineno )); return equalop;}
{notop}         {log( std::string( "notop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_NOTOP,yytext ,yylineno )); return notop;}
{quateop}       {log( std::string( "quateop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,yylineno )); return quateop;}
{addop}         {log( std::string( "addop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ADDOP,yytext ,yylineno )); return addop;}
{subop}         {log( std::string( "subop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SUBOP,yytext ,yylineno )); return subop;}
{or_op}         {log( std::string( "or_op:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OR_OP,yytext ,yylineno )); return or_op;}
{mulop}         {log( std::string( "mulop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_MULOP,yytext ,yylineno )); return mulop;}
{relop}         {log( std::string( "relop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RELOP,yytext ,yylineno )); return relop;}
{assignop}      {log( std::string( "assignop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ASSIGNOP,yytext ,yylineno )); return assignop;}
{blank}         {log( std::string( "blank:") + yytext, yylineno, DEBUG);}

{t_program}     {log( std::string( "t_program:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROGRAM,yytext ,yylineno )); return t_program;}
{t_const}       {log( std::string( "t_const:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CONST,yytext ,yylineno )); return t_const;}
{t_var}         {log( std::string( "t_var:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_VAR,yytext ,yylineno )); return t_var;}
{t_array}       {log( std::string( "t_array:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ARRAY,yytext ,yylineno )); return t_array;}
{t_of}          {log( std::string( "t_of:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OF,yytext ,yylineno )); return t_of;}
{t_integer}     {log( std::string( "t_integer:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_INTEGER,yytext ,yylineno )); return t_integer;}
{t_real}        {log( std::string( "t_real:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REAL,yytext ,yylineno )); return t_real;}
{t_boolean}     {log( std::string( "t_boolean:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BOOLEAN,yytext ,yylineno )); return t_boolean;}
{t_char}        {log( std::string( "t_char:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext ,yylineno )); return t_char;}
{t_while}       {log( std::string( "t_while:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext ,yylineno )); return t_while;}
{t_else}        {log( std::string( "t_else:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ELSE,yytext ,yylineno )); return t_else;}
{t_procedure}   {log( std::string( "t_procedure:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROCEDURE,yytext ,yylineno )); return t_procedure;}
{t_function}    {log( std::string( "t_function:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FUNCTION,yytext ,yylineno )); return t_function;}
{t_writeln}     {log( std::string( "t_writeln:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITELN,yytext ,yylineno )); return t_writeln;}
{t_readln}     {log( std::string( "t_readln:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READLN,yytext ,yylineno )); return t_readln;}
{t_double}    {log( std::string( "t_double:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE,yytext ,yylineno )); return t_double;}
{t_single}      {log( std::string( "t_single:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SINGLE,yytext ,yylineno )); return t_single;}
{t_longint}     {log( std::string( "t_longint:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LONGINT,yytext ,yylineno )); return t_longint;}
{t_byte}        {log( std::string( "t_byte:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BYTE,yytext ,yylineno )); return t_byte;}
{t_shortint}    {log( std::string( "t_shortint:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SHORTINT,yytext ,yylineno )); return t_shortint;}
{t_string}      {log( std::string( "t_string:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_STRING,yytext ,yylineno )); return t_string;}

{t_begin}       {log( std::string( "t_begin:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BEGIN,yytext ,yylineno )); return t_begin;}
{t_end}         {log( std::string( "t_end:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_END,yytext ,yylineno )); return t_end;}
{t_if}          {log( std::string( "t_if:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_IF,yytext ,yylineno )); return t_if;}
{t_then}        {log( std::string( "t_then:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_THEN,yytext ,yylineno )); return t_then;}
{t_for}         {log( std::string( "t_for:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FOR,yytext ,yylineno )); return t_for;}
{t_to}          {log( std::string( "t_to:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_TO,yytext ,yylineno )); return t_to;}
{t_do}          {log( std::string( "t_do:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DO,yytext ,yylineno )); return t_do;}

{t_dot}         {log( std::string( "t_dot:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOT,yytext ,yylineno )); return t_dot;}
{t_downto}      {log( std::string( "t_downto:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOWNTO,yytext ,yylineno )); return t_downto;}
{t_repeat}      {log( std::string( "t_repeat:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REPEAT,yytext ,yylineno )); return t_repeat;}
{t_until}       {log( std::string( "t_until:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_UNTIL,yytext ,yylineno )); return t_until;}
{t_case}        {log( std::string( "t_case:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CASE,yytext ,yylineno )); return t_case;}
{t_read}       {log( std::string( "t_read:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READ,yytext ,yylineno )); return t_read;}
{t_write}       {log( std::string( "t_write:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITE,yytext ,yylineno )); return t_write;}

{comment}         {log( std::string( "comment:") + yytext , yylineno, DEBUG);/* do nothing */}
{id}            {log( std::string( "id:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ID,yytext ,yylineno ));
                return id;
                }

%%
// {literal}       {log( std::string( "literal:") + yytext , yylineno, DEBUG); return literal;}
// {seperator}     {log( std::string( "seperator:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEPERATOR,yytext ,yylineno )); return yytext[0];}