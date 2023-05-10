%{
    #include <iostream>
    #include <string.h>
    #include "tools.h"
    #include "tree.h"
    #include "logger.h"
    using namespace logger;
    // extern "C"
    // {
    extern int yylex();
    extern int IsYaccError;
    extern int yylineno;
    extern char *yytext;
    void yyerror(char *s);
    // }

%}


%code requires{
    #include "tree.h"
    // typedef struct YYLTYPE
    // {
    //     int first_line;
    //     int first_column;
    //     int last_line;
    //     int last_column;
    // } YYLTYPE;
	// # define YYLTYPE_IS_DECLARED 1
    // extern YYLTYPE yylloc;
}

%union {
    char* str;
    char* num;
    TypeTree token_Tree;
}

%start programstruct
%token <token_Tree> num

%token <token_Tree> t_string
%token <token_Tree> t_char
%token <token_Tree> literal_string
%token <token_Tree> literal_char
%token <token_Tree> double_value
%token <token_Tree> t_writeln
%token <token_Tree> t_readln
%token <token_Tree> bool_value
%token <token_Tree> t_double
%token <token_Tree> t_longint
%token <token_Tree> t_byte
%token <token_Tree> t_single
%token <token_Tree> t_shortint

%token <token_Tree> id
%token <token_Tree> keyword
%token <token_Tree> addop mulop relop
%token <token_Tree> seperator
/* %token seperator */
%token <token_Tree> assignop
%token <token_Tree> literal

%token <token_Tree> t_program
%token <token_Tree> t_const
%token <token_Tree> t_var
%token <token_Tree> t_begin
%token <token_Tree> t_end
%token <token_Tree> t_if
%token <token_Tree> t_then
%token <token_Tree> t_else
%token <token_Tree> t_for
%token <token_Tree> t_to
%token <token_Tree> t_do
%token <token_Tree> t_read
%token <token_Tree> t_write
%token <token_Tree> t_array
%token <token_Tree> t_of
%token <token_Tree> t_procedure
%token <token_Tree> t_function
%token <token_Tree> t_integer
%token <token_Tree> t_real
%token <token_Tree> t_boolean
%token <token_Tree> t_dot
%token <token_Tree> t_downto
%token <token_Tree> t_while
%token <token_Tree> t_repeat
%token <token_Tree> t_until
%token <token_Tree> t_case
%token <token_Tree> or_op
%token <token_Tree> notop

%token <token_Tree> leftparen
%token <token_Tree> rightparen
%token <token_Tree> leftbracket
%token <token_Tree> rightbracket
%token <token_Tree> semicolon
%token <token_Tree> comma
%token <token_Tree> colon
%token <token_Tree> dot

%token <token_Tree> equalop
%token <token_Tree> quateop
%token <token_Tree> subop



%type <token_Tree> programstruct program_head program_body
%type <token_Tree> const_declarations const_declaration
%type <token_Tree> var_declarations var_declaration
%type <token_Tree> idlist const_value
%type <token_Tree> type basic_type formal_parameter value_parameter var_parameter
%type <token_Tree> subprogram_declarations subprogram subprogram_head subprogram_body
%type <token_Tree> parameter parameter_list
%type <token_Tree> compound_statement period
%type <token_Tree> optional_statements statement_list statement
%type <token_Tree> procedure_call
%type <token_Tree> else_part
%type <token_Tree> variable variable_list
%type <token_Tree> id_varpart expression_list
%type <token_Tree> expression simple_expression term factor case_expression_list


/* %type E T F */

%%

/* This is an example of defining productions with error handling */
/* TODO: Define productions */

/*
programstruct -> program_head ； program_body .
n program_head -> program id ( idlist ) | program id
n program_body -> const_declarations
var_declarations
subprogram_declarations
compound_statement
idlist -> id | idlist , id
const_declarations -> 空 | const const_declaration ;
const_declaration -> id = const_value | const_declaration ; id = const_value
2 

var_declarations -> 空 | var var_declaration ;
var_declaration -> idlist : type | var_declaration ; idlist : type
type -> basic_type | array [ period ] of basic_type
basic_type -> integer | real | boolean | char
period -> digits .. digits | period ， digits .. Digits
subprogram_declarations -> 空 | subprogram_declarations subprogram ;
subprogram -> subprogram_head ; subprogram_body
subprogram_head -> procedure id formal_parameter
| function id formal_parameter : basic_type
formal_parameter -> 空 | ( parameter_list )
parameter_list -> parameter | parameter_list ; parameter  

parameter -> var_parameter | value_parameter
var_parameter -> var value_parameter
value_parameter -> idlist : basic_type
subprogram_body -> const_declarations
var_declarations
compound_statement
compound_statement -> begin statement_list end
statement_list -> statement | statement_list ; statement  

statement -> 空
| variable assignop expression
| func_id assignop expression
| procedure_call
| compound_statement
| if expression then statement else_part
| for id assignop expression to expression do statement
| read ( variable_list )
| write ( expression_list )
variable_list -> variable | variable_list , variable
variable -> id id_varpart
id_varpart ->空 | [ expression_list ]  

procedure_call -> id | id ( expression_list )
else_part -> 空 | else statement
expression_list -> expression | expression_list , expression
expression -> simple_expression | simple_expression relop simple_expression
simple_expression -> term | simple_expression addop term
term -> factor | term mulop factor
factor -> num | variable
| ( expression )
| id ( expression_list )
| not factor
| uminus factor  
*/

//I need to define the productions above :
programstruct : program_head semicolon program_body dot { // pid = 1
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: programstruct -> program_head ; program_body .", pos, DEBUG); 
        tree::ast = tools::reduce({$1, $2, $3, $4}, pos,  tree::programstruct__T__programhead_semicolon__programbody_dot, tree::T_PROGRAM_STRUCT);
    }
    ;
program_head : t_program id leftparen idlist rightparen { // pid = 2
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: program_head -> program id ( idlist )", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::program_head__T__t_program__id_leftparen__idlist__rightparen , tree::T_PROGRAM_HEAD);
        }
    | t_program id { // pid = 3
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: program_head -> program id", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree:: program_head__T__t_program__id, tree::T_PROGRAM_HEAD);
        }
    | t_program error id{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error fixed and Use production: program_head -> program id", pos, DEBUG); 
        $$ = tools::reduce({$1, $3}, pos,  tree::program_head__T__t_program__id, tree::T_PROGRAM_HEAD);
        yyerrok;
    }
    ;


program_body : const_declarations var_declarations subprogram_declarations compound_statement { // pid = 4
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: program_body -> const_declarations var_declarations subprogram_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::program_body__T__const_declarations__var_declarations__subprogram_declarations__compound_statement
        // , $1
        , tree::T_PROGRAM_BODY);
        std::cout << @1.first_column<<std::endl;
        }
    | const_declarations var_declarations compound_statement { // pid=5
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: program_body -> const_declarations var_declarations compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::program_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | const_declarations subprogram_declarations compound_statement { // pid=6
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: program_body -> const_declarations subprogram_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::program_body__T__const_declarations__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | var_declarations subprogram_declarations compound_statement { // pid=7
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: program_body -> var_declarations subprogram_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::program_body__T__var_declarations__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | const_declarations compound_statement {  // pid=8
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: program_body -> const_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::program_body__T__const_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }

    | var_declarations compound_statement {  // pid=9
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: program_body -> var_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::program_body__T__var_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
    }
    | subprogram_declarations compound_statement {  // pid=10
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: program_body -> subprogram_declarations compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::program_body__T__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | compound_statement {  // pid=11
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: program_body -> compound_statement", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::program_body__T__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    ;

idlist : id {  // pid=12
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: idlist -> id", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::idlist__T__id
        , tree::T_IDLIST);
        }
    | idlist comma id {  // pid=13
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: idlist -> idlist , id", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::idlist__T__idlist__comma__id
        , tree::T_IDLIST);
        }
    | idlist error id {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error that lack of comma is fixed and use production: idlist -> idlist id", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_COMMA, ",", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::idlist__T__idlist__comma__id
        , tree::T_IDLIST);
        yyerrok;
        }
    ;

const_declarations :
    t_const const_declaration semicolon {  // pid=14
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: const_declarations -> const const_declaration ;", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::const_declarations__T__t_const__const_declaration__semicolon
        , tree::T_CONST_DECLARATIONS);
        }

const_declaration : id equalop const_value {  // pid=15
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: const_declaration -> id = constant", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::const_declaration__T__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
    }
    | id error equalop const_value {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error that lack of equalop is fixed and use production: const_declaration -> id = constant", pos, ERROR);
        $$ = tools::reduce({$1, $3, $4}, pos,  tree::const_declaration__T__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
        yyerrok;
    }
    | id error const_value {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error that lack of equalop is fixed and use production: const_declaration -> id = constant", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_EQUALOP, "=", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::const_declaration__T__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
        yyerrok;
    }
    | const_declaration semicolon id equalop const_value {  // pid=16
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: const_declaration -> const_declaration , id = constant", pos, DEBUG); 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::const_declaration__T__const_declaration__semicolon__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
        }
    ;

const_value : num {  // pid=17
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: const_value -> num", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::const_value__T__num
        , tree::T_CONST_VALUE);
        }
    | addop num {  // pid=18
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: const_value -> + num", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::const_value__T__addop__num
        , tree::T_CONST_VALUE);
        }
    | addop error num {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and use production: const_value -> +  num", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::const_value__T__addop__num
        , tree::T_CONST_VALUE);
        yyerrok;
        }
    | subop num {  // pid=19
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: const_value -> - num", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::const_value__T__subop__num
        , tree::T_CONST_VALUE);
        }
    | subop error num {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and use production: const_value -> -  num", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::const_value__T__subop__num
        , tree::T_CONST_VALUE);
        yyerrok;
        }
    | literal_string {  // pid=20
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: const_value -> literal", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::const_value__T__literal_string
        , tree::T_CONST_VALUE);
        }
    | literal_char{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: const_value -> literal_char", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::const_value__T__literal_char
        , tree::T_CONST_VALUE);
    }
    | addop double_value {  // pid=21
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: const_value -> + double_value", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::const_value__T__addop__double_value
        , tree::T_CONST_VALUE);
        }
    | addop error double_value {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and use production: const_value -> +  double_value", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::const_value__T__subop__double_value
        , tree::T_CONST_VALUE);
        yyerrok;
        }
    | subop double_value {  // pid=22
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: const_value -> - double_value", pos, DEBUG); 
        $$ = tools::reduce({$1, $2}, pos,  tree::const_value__T__subop__double_value
        , tree::T_CONST_VALUE);
        }
    | subop error double_value {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and use production: const_value -> - double_value", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::const_value__T__subop__double_value
        , tree::T_CONST_VALUE);
        yyerrok;
        }
    | double_value {  // pid=23
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: const_value -> double_value", pos, DEBUG); 
        $$ = tools::reduce({$1}, pos,  tree::const_value__T__double_value
        , tree::T_CONST_VALUE);
        }
    ;
    // to do 

var_declarations :
    t_var var_declaration semicolon {  // pid=21
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: var_declarations -> var var_declaration ;", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::var_declarations__T__t_var__var_declaration__semicolon
        , tree::T_VAR_DECLARATIONS);
    }
    ;

var_declaration : idlist colon type {  // pid=22
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: var_declaration -> id_list : type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::var_declaration__T__idlist__colon__type
        , tree::T_VAR_DECLARATION);
    }
    | idlist colon error type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and use production: var_declaration -> id_list : type", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::var_declaration__T__idlist__colon__type
        , tree::T_VAR_DECLARATION);
        yyerrok;
    }
    | idlist error type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error that lack of colon fixed and use production: var_declaration -> id_list : type", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_COLON, ":", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::var_declaration__T__idlist__colon__type
        , tree::T_VAR_DECLARATION);
        yyerrok;
    }
    | var_declaration semicolon idlist colon type {  // pid=23
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: var_declaration -> var_declaration ; id_list : type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::var_declaration__T__var_declaration__semicolon__idlist__colon__type
        , tree::T_VAR_DECLARATION);
    }
    ;

type : basic_type {  // pid=24
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: type -> basic_type", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::type__T__basic_type
        , tree::T_TYPE);
    }
    | t_array leftbracket period rightbracket t_of basic_type {  // pid=25
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $6->get_root()->get_position().last_line, $6->get_root()->get_position().last_column };
        log( "Use production: type -> array [ num ] of basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
    }
    | t_array leftbracket error period rightbracket t_of basic_type {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $7->get_root()->get_position().last_line, $7->get_root()->get_position().last_column };
        log( "error that lack of num fixed and use production: type -> array [ period ] of basic_type", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4, $5, $6, $7}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
        yyerrok;
    }
    | t_array error leftbracket period rightbracket t_of basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $7->get_root()->get_position().last_line, $7->get_root()->get_position().last_column };
        log( "error that lack of leftbracket fixed and use production: type -> array [ num ] of basic_type", pos, ERROR);
        $$ = tools::reduce({$1, $3, $4, $5, $6, $7}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
        yyerrok;
    }
    | t_array leftbracket period error rightbracket t_of basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $7->get_root()->get_position().last_line, $7->get_root()->get_position().last_column };
        log( "error that lack of rightbracket fixed and use production: type -> array [ num of basic_type", pos, ERROR);
        $$ = tools::reduce({$1, $2, $3, $5, $6, $7}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
        yyerrok;
    }
    | t_array leftbracket period rightbracket error t_of basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $7->get_root()->get_position().last_line, $7->get_root()->get_position().last_column };
        log( "error that lack of t_of fixed and use production: type -> array [ num ] of basic_type", pos, ERROR);
        $$ = tools::reduce({$1, $2, $3, $4, $6, $7}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
        yyerrok;
    }
    | t_array leftbracket period rightbracket t_of error basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $7->get_root()->get_position().last_line, $7->get_root()->get_position().last_column };
        log( "error that lack of basic_type fixed and use production: type -> array [ num ] of basic_type", pos, ERROR);
        $$ = tools::reduce({$1, $2, $3, $4, $5, $7}, pos,  tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
        yyerrok;
    }
    ;
    
basic_type : t_integer {  // pid=26
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> integer", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_integer
        , tree::T_BASIC_TYPE);
    }
    | t_single {  // pid=27
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> single", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_single
        , tree::T_BASIC_TYPE);
    }
    | t_boolean {  // pid=28
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> boolean", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_boolean
        , tree::T_BASIC_TYPE);
    }
    | t_char {  // pid=29
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> char", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_char
        , tree::T_BASIC_TYPE);
    }
    | t_string {  // pid=30
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> string", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_string
        , tree::T_BASIC_TYPE);
    }
    | t_longint {  // pid=30
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> longint", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_longint
        , tree::T_BASIC_TYPE);
    }
    | t_byte {  // pid=30
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> byte", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_byte
        , tree::T_BASIC_TYPE);
    }
    | t_double {  // pid=30
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: basic_type -> double", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::basic_type__T__t_double
        , tree::T_BASIC_TYPE);
    }
    ;
    
period : num t_dot num {  // pid=29
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: period -> num .. num", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::period__T__num__t_dot__num
        , tree::T_PERIOD);
    }
    | num error num {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: period -> num .. num", pos, DEBUG);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_DOT, "..", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::period__T__num__t_dot__num
        , tree::T_PERIOD);
        yyerrok;
    }
    | num t_dot error num {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: period -> num .. num", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::period__T__num__t_dot__num
        , tree::T_PERIOD);
        yyerrok;
    }
    | period comma num t_dot num {  // pid=30
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: period -> period , num . num", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::period__T__period__comma__num__t_dot__num
        , tree::T_PERIOD);
    }
    ;

subprogram_declarations : subprogram semicolon {  // pid=31
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::subprogram_declarations__T__subprogram__semicolon
        , tree::T_SUBPROGRAM_DECLARATIONS);
    } 
    | subprogram error semicolon{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;", pos, DEBUG);
        $$ = tools::reduce({$1, $3}, pos,  tree::subprogram_declarations__T__subprogram__semicolon
        , tree::T_SUBPROGRAM_DECLARATIONS);
        yyerrok;
    }
    | subprogram_declarations subprogram semicolon {  // pid=32
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: subprogram_declarations -> subprogram_declaration ;", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::subprogram_declarations__T__subprogram_declarations__subprogram__semicolon
        , tree::T_SUBPROGRAM_DECLARATIONS);
    }
    ;

subprogram : subprogram_head semicolon subprogram_body {  // pid=33
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: subprogram -> subprogram_head ; subprogram_declarations compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::subprogram__T__subprogram_head__semicolon__subprogram_body
        , tree::T_SUBPROGRAM);
    }
    ;

subprogram_head : 
      t_function id formal_parameter colon basic_type {  // pid=34
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: subprogram_head -> function id formal_parameter : basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_function id formal_parameter error basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_head -> function id formal_parameter : basic_type", pos, DEBUG);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_COLON, ":", pos));
        $$ = tools::reduce({$1, $2, $3, tnode, $5}, pos,  tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
        yyerrok;
    }
    | t_function id formal_parameter error colon basic_type {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $6->get_root()->get_position().last_line, $6->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_head -> function id formal_parameter : basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $5, $6}, pos,  tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
        yyerrok;
    }
    | t_procedure id formal_parameter {  // pid=35
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: subprogram_head -> procedure id formal_parameter", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::subprogram_head__T__t_procedure__id__formal_parameter
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id error formal_parameter {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_head -> procedure id formal_parameter", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::subprogram_head__T__t_procedure__id__formal_parameter
        , tree::T_SUBPROGRAM_HEAD);
        yyerrok;
    }
    | t_function id colon basic_type {  // pid=36
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: subprogram_head -> function id : basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::subprogram_head__T__t_function__id__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id {  // pid=37
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: subprogram_head -> procedure id", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::subprogram_head__T__t_procedure__id
        , tree::T_SUBPROGRAM_HEAD);
    };

formal_parameter : leftparen parameter_list rightparen {  // pid=38
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: formal_parameter -> ( parameter_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::formal_parameter__T__leftparen__parameter_list__rightparen
        , tree::T_FORMAL_PARAMETER);
    }
    | leftparen parameter_list error rightparen {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: formal_parameter -> ( parameter_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::formal_parameter__T__leftparen__parameter_list__rightparen
        , tree::T_FORMAL_PARAMETER);
        yyerrok;
    }
    |leftparen rightparen{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: formal_parameter -> ( )", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::formal_parameter__T__leftparen__rightparen
        , tree::T_FORMAL_PARAMETER);
    };

parameter_list : parameter {  // pid=39
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: parameter_list -> parameter", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::parameter_list__T__parameter
        , tree::T_PARAMETER_LIST);
    }
    | parameter_list semicolon parameter {  // pid=40
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: parameter_list -> parameter_list ; parameter", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::parameter_list__T__parameter_list__semicolon__parameter
        , tree::T_PARAMETER_LIST);
    }
    ;

parameter :  var_parameter {  // pid=41
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: parameter -> var_parameter", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::parameter__T__var_parameter
        , tree::T_PARAMETER);
    }
    | value_parameter {  // pid=42
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: parameter -> value_parameter", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::parameter__T__value_parameter
        , tree::T_PARAMETER);
    };

var_parameter : t_var value_parameter {  // pid=43
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: var_parameter -> var value_parameter", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::var_parameter__T__t_var__value_parameter
        , tree::T_VAR_PARAMETER);
    };
    
value_parameter : idlist colon basic_type {  // pid=44
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: value_parameter -> idlist : basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::value_parameter__T__idlist__colon__basic_type
        , tree::T_VALUE_PARAMETER);
    }
    | idlist error basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: value_parameter -> idlist : basic_type", pos, DEBUG);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_COLON, ":", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::value_parameter__T__idlist__colon__basic_type
        , tree::T_VALUE_PARAMETER);
        yyerrok;
    }
    | idlist error colon basic_type{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: value_parameter -> idlist : basic_type", pos, DEBUG);
        $$ = tools::reduce({$1, $3, $4}, pos,  tree::value_parameter__T__idlist__colon__basic_type
        , tree::T_VALUE_PARAMETER);
        yyerrok;
    }
    ;

subprogram_body : compound_statement {  // pid=45
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: subprogram_body -> compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::subprogram_body__T__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations compound_statement {  // pid=46
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: subprogram_body -> const_declarations compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::subprogram_body__T__const_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations error compound_statement{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_body -> const_declaration compound_statement", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::subprogram_body__T__const_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
        yyerrok;
    }
    | var_declarations compound_statement{    // pid=47
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: subprogram_body -> var_declarations compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::subprogram_body__T__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | var_declarations error compound_statement{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_body -> var_declarations compound_statement", pos, ERROR);
        $$ = tools::reduce({$1, $3}, pos,  tree::subprogram_body__T__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
        yyerrok;
    }
    | const_declarations var_declarations compound_statement{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: subprogram_body -> const_declarations var_declarations compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::subprogram_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations error var_declarations compound_statement {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_body -> const_declarations var_declarations compound_statement", pos, ERROR);
        $$ = tools::reduce({$1, $3, $4}, pos,  tree::subprogram_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
        yyerrok;
    }
    | const_declarations var_declarations error compound_statement {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: subprogram_body -> const_declarations var_declarations compound_statement", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::subprogram_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
        yyerrok;
    }
    ;

compound_statement : t_begin statement_list t_end {  // pid=48
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: compound_statement -> begin statement_list end", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::compound_statement__T__t_begin__statement_list__t_end
        , tree::T_COMPOUND_STATEMENT);
    }
    | t_begin statement_list semicolon t_end{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: compound_statement -> begin statement_list ; end", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::compound_statement__T__t_begin__statement_list__semicolon__t_end
        , tree::T_COMPOUND_STATEMENT);
    }
    | t_begin t_end{    // pid=49
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: compound_statement -> begin end", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::compound_statement__T__t_begin__t_end
        , tree::T_COMPOUND_STATEMENT);
    }

statement_list : statement {  // pid=50
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: statement_list -> statement", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::statement_list__T__statement, tree::T_STATEMENT_LIST);
    }| statement_list semicolon statement {  // pid=51
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: statement_list -> statement_list ; statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::statement_list__T__statement_list__semicolon__statement
        , tree::T_STATEMENT_LIST);
    };

statement : variable assignop expression {  // pid=52
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: statement -> variable assignop expression", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::statement__T__variable__assignop__expression
        , tree::T_STATEMENT);
    }
    | variable error expression {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> variable assignop expression", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_ASSIGNOP, ":=", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::statement__T__variable__assignop__expression
        , tree::T_STATEMENT);
        yyerrok;
    }
    | procedure_call {  // pid=54
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: statement -> procedure_call", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::statement__T__procedure_call
        , tree::T_STATEMENT);
    }
    | compound_statement {  // pid=55
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: statement -> compound_statement", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::statement__T__compound_statement
        , tree::T_STATEMENT);
    }  
    // 54 to do
    | t_if expression t_then statement {  // pid=56
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> if expression then statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_if__expression__t_then__statement
        , tree::T_STATEMENT);
    }
    | t_if expression error statement {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> if expression then statement", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_THEN, "then", pos));
        $$ = tools::reduce({$1, $2, tnode, $4}, pos,  tree::statement__T__t_if__expression__t_then__statement
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_if expression t_then statement else_part  {  // pid=56
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "Use production: statement -> if expression then statement else_part", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5}, pos,  tree::statement__T__t_if__expression__t_then__statement__else_part
        , tree::T_STATEMENT);
    }
    | t_if expression error statement else_part {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> if expression then statement else_part", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_THEN, "then", pos));
        $$ = tools::reduce({$1, $2, tnode, $4, $5}, pos,  tree::statement__T__t_if__expression__t_then__statement__else_part
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_if expression error t_then statement else_part {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $6->get_root()->get_position().last_line, $6->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> if expression then statement else_part", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4, $5, $6}, pos,  tree::statement__T__t_if__expression__t_then__statement__else_part
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_while expression t_do statement {  // pid=57
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> while expression do statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_while__T__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_while expression error t_do statement {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> while expression do statement", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4, $5}, pos,  tree::statement__T__t_while__T__expression__t_do__statement
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_while expression error statement {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> while expression do statement", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_DO, "do", pos));
        $$ = tools::reduce({$1, $2, tnode, $4}, pos,  tree::statement__T__t_while__T__expression__t_do__statement
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_repeat statement_list t_until expression {  // pid=58
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> repeat statement_list until expression", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_repeat__statement_list__t_until__expression
        , tree::T_STATEMENT);
    }
    | t_repeat statement_list error t_until expression {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> repeat statement_list until expression", pos, ERROR);
        $$ = tools::reduce({$1, $2, $4, $5}, pos,  tree::statement__T__t_repeat__statement_list__t_until__expression
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_repeat statement_list error expression {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> repeat statement_list until expression", pos, ERROR);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_UNTIL, "until", pos));
        $$ = tools::reduce({$1, $2, tnode, $4}, pos,  tree::statement__T__t_repeat__statement_list__t_until__expression
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_for id assignop expression t_to expression t_do statement {  // pid=59
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $8->get_root()->get_position().last_line, $8->get_root()->get_position().last_column };
        log( "Use production: statement -> for id assignop expression to expression do statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7, $8}, pos,  tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_for id assignop expression t_downto expression t_do statement {  // pid=60
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $8->get_root()->get_position().last_line, $8->get_root()->get_position().last_column };
        log( "Use production: statement -> for id assignop expression downto expression do statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7, $8}, pos,  tree::statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_read leftparen variable_list rightparen {  // pid=61
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> read ( idlist )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_read__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_readln leftparen variable_list rightparen {  // pid=61
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: statement -> readln ( idlist )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_readln__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_readln error leftparen variable_list rightparen {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $5->get_root()->get_position().last_line, $5->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> readln ( idlist )", pos, DEBUG);
        $$ = tools::reduce({$1, $3, $4, $5}, pos,  tree::statement__T__t_readln__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_readln error variable_list rightparen {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: statement -> readln ( idlist )", pos, DEBUG);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_LEFTPAREN, "(", pos));
        $$ = tools::reduce({$1, tnode, $3, $4}, pos,  tree::statement__T__t_readln__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
        yyerrok;
    }
    | t_write leftparen expression_list rightparen {  // pid=62
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> write ( expression_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_write__leftparen__expression_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_writeln leftparen expression_list rightparen {  // pid=62
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: statement -> writeln ( expression_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::statement__T__t_writeln__leftparen__expression_list__rightparen
        , tree::T_STATEMENT);
    }
    ;

variable_list : variable {  // pid=63
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: variable_list -> variable", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::variable_list__T__variable
        , tree::T_VARIABLE_LIST);
    }
    | variable_list comma variable {  // pid=64
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: variable_list -> variable_list , variable", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::variable_list__T__variable_list__comma__variable
        , tree::T_VARIABLE_LIST);
    }
    | variable_list error comma variable {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: variable_list -> variable_list , variable", pos, DEBUG);
        $$ = tools::reduce({$1, $3, $4}, pos,  tree::variable_list__T__variable_list__comma__variable
        , tree::T_VARIABLE_LIST);
        yyerrok;
    }
    | variable_list error variable {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: variable_list -> variable_list , variable", pos, DEBUG);
        tree::Tree* tnode = new tree::Tree(new tree::TreeNode(tree::leaf_pid, tree::T_COMMA, ",", pos));
        $$ = tools::reduce({$1, tnode, $3}, pos,  tree::variable_list__T__variable_list__comma__variable
        , tree::T_VARIABLE_LIST);
        yyerrok;
    }
    ;

variable : id {  // pid=65
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: variable -> id", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::variable__T__id
        , tree::T_VARIABLE, $1->get_root()->get_text());
    }
    | id id_varpart {  // pid=66
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: variable -> id id_varpart", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::variable__T__id__id_varpart
        , tree::T_VARIABLE, $1->get_root()->get_text()+' '+$2->get_root()->get_text());
    }
    | id error id_varpart {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "error is fixed and Use production: variable -> id id_varpart", pos, DEBUG);
        $$ = tools::reduce({$1, $3}, pos,  tree::variable__T__id__id_varpart
        , tree::T_VARIABLE, $1->get_root()->get_text()+' '+$3->get_root()->get_text());
        yyerrok;
    }
    ;

id_varpart : leftbracket expression_list rightbracket {  // pid=67
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: id_varpart -> [ expression ]", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::id_varpart__T__leftbracket__expression_list__rightbracket
        , tree::T_ID_VARPART, $1->get_root()->get_text()+' '+$2->get_root()->get_text()+' '+$3->get_root()->get_text());
    }
    | leftbracket expression_list error rightbracket {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "error is fixed and Use production: id_varpart -> [ expression ]", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $4}, pos,  tree::id_varpart__T__leftbracket__expression_list__rightbracket
        , tree::T_ID_VARPART, $1->get_root()->get_text()+' '+$2->get_root()->get_text()+' '+$4->get_root()->get_text());
        yyerrok;
    }
    ;

procedure_call : id leftparen expression_list rightparen {  // pid=68
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: procedure_call -> id ( expression_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::procedure_call__T__id__leftparen__expression_list__rightparen
        , tree::T_PROCEDURE_CALL);
    }
    | id { // pid=69
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: procedure_call -> id", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::procedure_call__T__id
        , tree::T_PROCEDURE_CALL);
    }
    | id leftparen rightparen{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: procedure_call -> id ( )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::procedure_call__T__id__leftparen__rightparen
        , tree::T_PROCEDURE_CALL);
    };

else_part : t_else statement {  // pid=70
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: else_part -> else statement", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::else_part__T__t_else__statement
        , tree::T_ELSE_PART);
    }
    | t_else  {  // pid = 71
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        $$ = tools::reduce({$1}, pos,  tree::else_part__T__t_else
        , tree::T_ELSE_PART);
    };

expression_list : expression_list comma expression {  // pid=72
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: expression_list -> expression_list , expression", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::expression_list__T__expression_list__comma__expression
        , tree::T_EXPRESSION_LIST, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    |expression {   // pid=73
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: expression_list -> expression", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::expression_list__T__expression
        , tree::T_EXPRESSION_LIST, $1->get_root()->get_text());
    };

expression : simple_expression {  
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: expression -> simple_expression", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::expression__T__simple_expression
        , tree::T_EXPRESSION, $1->get_root()->get_text());
    }
    | simple_expression relop simple_expression {  // pid=75
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: expression -> simple_expression relop simple_expression", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::expression__T__simple_expression__relop__simple_expression
        , tree::T_EXPRESSION, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | simple_expression equalop simple_expression {  // pid=76
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: expression -> simple_expression = simple_expression", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::expression__T__simple_expression__equalop__simple_expression
        , tree::T_EXPRESSION, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    };

simple_expression : term {  // pid=77
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> term", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::simple_expression__T__term
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text());
    }
    | simple_expression addop term {  // pid=78
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> term addop term", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::simple_expression__T__term__addop__term
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | simple_expression subop term {  // pid=79
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> term subop term", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::simple_expression__T__term__subop__term
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | simple_expression or_op term {  // pid=80
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> term orop term", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::simple_expression__T__term__or_op__term
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | literal_string{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> literal_string", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::simple_expression__T__literal_string
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text());
    }
    | literal_char{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: simple_expression -> literal_char", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::simple_expression__T__literal_char
        , tree::T_SIMPLE_EXPRESSION, $1->get_root()->get_text());
    };

term : factor {  // pid=81
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: term -> factor", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::term__T__factor
        , tree::T_TERM, $1->get_root()->get_text());
    }
    | term mulop factor {  // pid=82
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: term -> term mulop factor", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::term__T__term__mulop__factor
        , tree::T_TERM, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }

factor : leftparen expression rightparen {  // pid=83
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: factor -> ( expression )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::factor__T__leftparen__expression__rightparen
        , tree::T_FACTOR, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | variable {  // pid=84
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: factor -> variable", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::factor__T__variable
        , tree::T_FACTOR, $1->get_root()->get_text());
    }
    | id leftparen expression_list rightparen {  // pid=85
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $4->get_root()->get_position().last_line, $4->get_root()->get_position().last_column };
        log( "Use production: factor -> id ( expression_list )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3, $4}, pos,  tree::factor__T__id__leftparen__expression_list__rightparen
        , tree::T_FACTOR, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text()+" "+$4->get_root()->get_text());
    }
    | id leftparen rightparen{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $3->get_root()->get_position().last_line, $3->get_root()->get_position().last_column };
        log( "Use production: factor -> id ( )", pos, DEBUG);
        $$ = tools::reduce({$1, $2, $3}, pos,  tree::factor__T__id__leftparen__rightparen
        , tree::T_FACTOR, $1->get_root()->get_text()+" "+$2->get_root()->get_text()+" "+$3->get_root()->get_text());
    }
    | num { // pid=86
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: factor -> num", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::factor__T__num
        , tree::T_FACTOR, $1->get_root()->get_text());
    }
    | double_value {
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: factor -> double_value", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::factor__T__double_value
        , tree::T_FACTOR, $1->get_root()->get_text());
    }
    | notop factor {  // pid=87
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: factor -> notop factor", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::factor__T__notop__factor
        , tree::T_FACTOR, $1->get_root()->get_text()+" "+$2->get_root()->get_text());
    }
    | subop factor {  // pid=88
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $2->get_root()->get_position().last_line, $2->get_root()->get_position().last_column };
        log( "Use production: factor -> - factor", pos, DEBUG);
        $$ = tools::reduce({$1, $2}, pos,  tree::factor__T__subop__factor
        , tree::T_FACTOR, $1->get_root()->get_text()+" "+$2->get_root()->get_text());
    }
    | bool_value{
        tree::Position pos = {$1->get_root()->get_position().first_line, $1->get_root()->get_position().first_column, $1->get_root()->get_position().last_line, $1->get_root()->get_position().last_column };
        log( "Use production: factor -> bool_value", pos, DEBUG);
        $$ = tools::reduce({$1}, pos,  tree::factor__T__bool_value
        , tree::T_FACTOR, $1->get_root()->get_text());
    };

%%

/* Error log, should not be modified at present */
void yyerror(char *s) {
    if (strlen(yytext) == 0) {
        log( std::string("Error: " )+ std::string("end of file: ") +std::string("missing operand or block end"), yylineno);
    } else {
        log( std::string("Error: ") + std::string(s) + std::string(" at line: ") + std::to_string(yylineno) + std::string(", encountering unexpected word ") + yytext, yylineno );
    }
}