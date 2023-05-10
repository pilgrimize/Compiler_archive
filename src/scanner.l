%option noyywrap
%option yylineno

%{
    #include<iostream>
    #include<vector>
    #include<cstring>

    #include "parser.h"
    extern YYLTYPE yylloc;
    static int curr_col=1;
    static int curr_line=1;
    #define YY_USER_ACTION \
    yylloc.first_line   = curr_line;\
    yylloc.first_column = curr_col;\
    {\
        char * s; \
        for(s = yytext; *s != '\0'; s++)\
        {\
            if(*s == '\n'){\
            curr_line++;\
            curr_col = 1;\
            }\
            else{\
            curr_col++;\
            }\
        }\
    }\
    yylloc.last_line   = curr_line;\
    yylloc.last_column = curr_col-1;\

    #include "logger.h"
    using namespace logger;
    std::vector<std::string> comment_vector; 
    
    int word_count = 0;
    int line_count = 0;
    int char_count = 0;
    int const_count = 0;
    int id_count = 0;
    int keyword_count = 0;
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
semicolon [";"]+
comma ","
colon ":"
dot "."
letter [a-zA-Z]
digit [0-9]
digits ({digit})+
optional_fraction "."{digits}
num {digits}
double_value [0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?
others "@"|"#"|"$"|"%"|"^"|"&"|"*"|"-"|"+"|"="|"|"|"["|"]"|"{"|"}"|";"|":"|","|"<"|">"|"/"|"?"|"~"|" "|"!"|" "
id ({letter}|"_")({letter}|{digit}|"_")*
comment \{[^}]*\}

unexpected_char_error [@`]
unwrapped_string_error \'[^\n\']*

%x BLOCK_COMMENT

%%

{num}           {log( std::string( "num:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_INT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear();
                return num;
                }
{double_value}    {log( std::string( "double_value:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE_VALUE ,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear();
                return double_value;
                }
{bool_value}   {log( std::string( "bool_value:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_BOOL ,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear();
                return bool_value;
                }
{literal_char} {log( std::string( "literal_char:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_CHAR ,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear();
                return literal_char;
                }
{literal_string} {log( std::string( "literal_string:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_STRING ,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear();
                return literal_string;
                }
{comment}       {
                log( std::string( "comment:") + yytext , yylineno, DEBUG);
                comment_vector.push_back(yytext);
                }
{leftparen}     {log( std::string( "leftparen:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTPAREN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return leftparen;}
{rightparen}    {log( std::string( "rightparen:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTPAREN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return rightparen;}
{leftbracket}   {log( std::string( "leftbracket:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LEFTBRACKET,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return leftbracket;}
{rightbracket}  {log( std::string( "rightbracket:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RIGHTBRACKET,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return rightbracket;}
{semicolon}     {log( std::string( "semicolon:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEMICOLON,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return semicolon;}
{comma}         {log( std::string( "comma:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COMMA,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return comma;}
{colon}         {log( std::string( "colon:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_COLON,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return colon;}
{dot}           {log( std::string( "dot:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::DOT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return dot;}

{equalop}       {log( std::string( "equalop:") + yytext , yylineno, DEBUG); yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return equalop;}
{notop}         {log( std::string( "notop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_NOTOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return notop;}
{quateop}       {log( std::string( "quateop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_QUATEOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return quateop;}
{addop}         {log( std::string( "addop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ADDOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return addop;}
{subop}         {log( std::string( "subop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SUBOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return subop;}
{or_op}         {log( std::string( "or_op:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OR_OP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return or_op;}
{mulop}         {log( std::string( "mulop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_MULOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return mulop;}
{relop}         {log( std::string( "relop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_RELOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return relop;}
{assignop}      {log( std::string( "assignop:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ASSIGNOP,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return assignop;}
{blank}         {log( std::string( "blank:") + yytext, yylineno, DEBUG);}

{t_program}     {log( std::string( "t_program:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROGRAM,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_program;}
{t_const}       {log( std::string( "t_const:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CONST,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_const;}
{t_var}         {log( std::string( "t_var:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_VAR,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_var;}
{t_array}       {log( std::string( "t_array:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ARRAY,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_array;}
{t_of}          {log( std::string( "t_of:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_OF,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_of;}
{t_integer}     {log( std::string( "t_integer:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_INTEGER,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_integer;}
{t_real}        {log( std::string( "t_real:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REAL,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_real;}
{t_boolean}     {log( std::string( "t_boolean:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BOOLEAN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_boolean;}
{t_char}        {log( std::string( "t_char:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CHAR,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_char;}
{t_while}       {log( std::string( "t_while:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WHILE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_while;}
{t_else}        {log( std::string( "t_else:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ELSE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_else;}
{t_procedure}   {log( std::string( "t_procedure:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_PROCEDURE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_procedure;}
{t_function}    {log( std::string( "t_function:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FUNCTION,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_function;}
{t_writeln}     {log( std::string( "t_writeln:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITELN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_writeln;}
{t_readln}     {log( std::string( "t_readln:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READLN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_readln;}
{t_double}    {log( std::string( "t_double:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOUBLE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_double;}
{t_single}      {log( std::string( "t_single:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SINGLE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_single;}
{t_longint}     {log( std::string( "t_longint:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LONGINT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_longint;}
{t_byte}        {log( std::string( "t_byte:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BYTE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_byte;}
{t_shortint}    {log( std::string( "t_shortint:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SHORTINT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_shortint;}
{t_string}      {log( std::string( "t_string:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_STRING,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_string;}

{t_begin}       {log( std::string( "t_begin:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_BEGIN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_begin;}
{t_end}         {log( std::string( "t_end:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_END,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_end;}
{t_if}          {log( std::string( "t_if:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_IF,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_if;}
{t_then}        {log( std::string( "t_then:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_THEN,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_then;}
{t_for}         {log( std::string( "t_for:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_FOR,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_for;}
{t_to}          {log( std::string( "t_to:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_TO,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_to;}
{t_do}          {log( std::string( "t_do:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DO,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_do;}

{t_dot}         {log( std::string( "t_dot:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_dot;}
{t_downto}      {log( std::string( "t_downto:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_DOWNTO,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_downto;}
{t_repeat}      {log( std::string( "t_repeat:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_REPEAT,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_repeat;}
{t_until}       {log( std::string( "t_until:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_UNTIL,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_until;}
{t_case}        {log( std::string( "t_case:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_CASE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_case;}
{t_read}       {log( std::string( "t_read:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_READ,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_read;}
{t_write}       {log( std::string( "t_write:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_WRITE,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return t_write;}

{id}            {log( std::string( "id:") + yytext , yylineno, DEBUG);
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_ID,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column} , comment_vector));
                comment_vector.clear(); 
                return id;
                }

{unexpected_char_error} {log(std::string("Unexpected character: ")+yytext, yylineno, DEBUG);}
{unwrapped_string_error} {
                tree::Position position = {yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column};
                log(std::string("Unwrapped string: ")+yytext + std::string(" and now it is patched."), position, ERROR);
                std::string temp = yytext+'\'';
                yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_LITERAL_STRING, yytext, position, comment_vector));
                comment_vector.clear(); 
                return literal_string;
                }

<INITIAL>{
    "{" {BEGIN BLOCK_COMMENT; char_count += yyleng;}
}

<BLOCK_COMMENT>{
    <<EOF>> {log("Unfinished block comment", yylineno, ERROR); return 0;}
    "{" {BEGIN INITIAL; char_count += yyleng;}
}

%%
// {literal}       {log( std::string( "literal:") + yytext , yylineno, DEBUG); return literal;}
// {seperator}     {log( std::string( "seperator:") + yytext , yylineno, DEBUG);yylval.token_Tree = new tree::Tree(new tree::TreeNode(tree::leaf_pid,tree::T_SEPERATOR,yytext ,{yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column}, comment_vector)); comment_vector.clear(); return yytext[0];}