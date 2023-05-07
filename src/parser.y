%{
    #include <iostream>
    #include <string.h>
    #include "tools.h"
    #include "tree.h"
    // extern "C"
    // {
    extern int yylex();
    extern int yylineno;
    extern char *yytext;
    void yyerror(char *s);
    // }

%}


%code requires{
    #include "tree.h"
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
        std::cerr << "Use production: programstruct -> program_head ; program_body ." << std::endl; 
        tree::ast = tools::reduce({$1, $2, $3, $4}, tree::programstruct__T__programhead_semicolon__programbody_dot, tree::T_PROGRAM_STRUCT);
    }
    ;
program_head : t_program id leftparen idlist rightparen { // pid = 2
        std::cerr << "Use production: program_head -> program id ( idlist )" << std::endl; 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::program_head__T__t_program__id_leftparen__idlist__rightparen , tree::T_PROGRAM_HEAD);
        }
    | t_program id { // pid = 3
        std::cerr << "Use production: program_head -> program id" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree:: program_head__T__t_program__id, tree::T_PROGRAM_HEAD);
        }
    | error id leftparen idlist rightparen { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        }
    | error id { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        }
    ;


program_body : const_declarations var_declarations subprogram_declarations compound_statement { // pid = 4
        std::cerr << "Use production: program_body -> const_declarations var_declarations subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2, $3, $4}, tree::program_body__T__const_declarations__var_declarations__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);

        }
    | const_declarations var_declarations compound_statement { // pid=5
        std::cerr << "Use production: program_body -> const_declarations var_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::program_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | const_declarations subprogram_declarations compound_statement { // pid=6
        std::cerr << "Use production: program_body -> const_declarations subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, tree::program_body__T__const_declarations__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | var_declarations subprogram_declarations compound_statement { // pid=7
        std::cerr << "Use production: program_body -> var_declarations subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, tree::program_body__T__var_declarations__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | const_declarations compound_statement {  // pid=8
        std::cerr << "Use production: program_body -> const_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree::program_body__T__const_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }

    | var_declarations compound_statement {  // pid=9
        std::cerr << "Use production: program_body -> var_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree::program_body__T__var_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
    }
    | subprogram_declarations compound_statement {  // pid=10
        std::cerr << "Use production: program_body -> subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree::program_body__T__subprogram_declarations__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    | compound_statement {  // pid=11
        std::cerr << "Use production: program_body -> compound_statement" << std::endl; 
        $$ = tools::reduce({$1}, tree::program_body__T__compound_statement
        , tree::T_PROGRAM_BODY);
        }
    ;

idlist : id {  // pid=12
        std::cerr << "Use production: idlist -> id" << std::endl; 
        $$ = tools::reduce({$1}, tree::idlist__T__id
        , tree::T_IDLIST);
        }
    | idlist comma id {  // pid=13
        std::cerr << "Use production: idlist -> idlist , id" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::idlist__T__idlist__comma__id
        , tree::T_IDLIST);
        }
    ;

const_declarations :
    t_const const_declaration semicolon {  // pid=14
        std::cerr << "Use production: const_declarations -> const const_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::const_declarations__T__t_const__const_declaration__semicolon
        , tree::T_CONST_DECLARATIONS);
        }

const_declaration : id equalop const_value {  // pid=15
        std::cerr << "Use production: const_declaration -> id = constant" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, tree::const_declaration__T__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
    }
    | const_declaration semicolon id equalop const_value {  // pid=16
        std::cerr << "Use production: const_declaration -> const_declaration , id = constant" << std::endl; 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::const_declaration__T__const_declaration__semicolon__id__equalop__const_value
        , tree::T_CONST_DECLARATION);
        }
    ;

const_value : num {  // pid=17
        std::cerr << "Use production: const_value -> num" << std::endl; 
        $$ = tools::reduce({$1}, tree::const_value__T__num
        , tree::T_CONST_VALUE);
        }
    | addop num {  // pid=18
        std::cerr << "Use production: const_value -> + num" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree::const_value__T__addop__num
        , tree::T_CONST_VALUE);
        }
    | subop num {  // pid=19
        std::cerr << "Use production: const_value -> - num" << std::endl; 
        $$ = tools::reduce({$1, $2}, tree::const_value__T__subop__num
        , tree::T_CONST_VALUE);
        }
    | literal {  // pid=20
        std::cerr << "Use production: const_value -> literal" << std::endl; 
        $$ = tools::reduce({$1}, tree::const_value__T__literal
        , tree::T_CONST_VALUE);
        }
    ;
    // to do 

var_declarations :
    t_var var_declaration semicolon {  // pid=21
        std::cerr << "Use production: var_declarations -> var var_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::var_declarations__T__t_var__var_declaration__semicolon
        , tree::T_VAR_DECLARATIONS);
    }
    ;

var_declaration : idlist colon type {  // pid=22
        std::cerr << "Use production: var_declaration -> id_list : type" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::var_declaration__T__idlist__colon__type
        , tree::T_VAR_DECLARATION);
    }
    | var_declaration semicolon idlist colon type {  // pid=23
        std::cerr << "Use production: var_declaration -> var_declaration ; id_list : type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::var_declaration__T__var_declaration__semicolon__idlist__colon__type
        , tree::T_VAR_DECLARATION);
    }
    ;

type : basic_type {  // pid=24
        std::cerr << "Use production: type -> basic_type" << std::endl;
        $$ = tools::reduce({$1}, tree::type__T__basic_type
        , tree::T_TYPE);
    }
    | t_array leftbracket period rightbracket t_of basic_type {  // pid=25
        std::cerr << "Use production: type -> array [ num ] of basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6}, tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type
        , tree::T_TYPE);
    }
    ;
    
basic_type : t_integer {  // pid=26
        std::cerr << "Use production: basic_type -> integer" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_integer
        , tree::T_BASIC_TYPE);
    }
    | t_single {  // pid=27
        std::cerr << "Use production: basic_type -> single" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_single
        , tree::T_BASIC_TYPE);
    }
    | t_boolean {  // pid=28
        std::cerr << "Use production: basic_type -> boolean" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_boolean
        , tree::T_BASIC_TYPE);
    }
    | t_char {  // pid=29
        std::cerr << "Use production: basic_type -> char" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_char
        , tree::T_BASIC_TYPE);
    }
    | t_string {  // pid=30
        std::cerr << "Use production: basic_type -> string" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_string
        , tree::T_BASIC_TYPE);
    }
    | t_longint {  // pid=30
        std::cerr << "Use production: basic_type -> longint" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_longint
        , tree::T_BASIC_TYPE);
    }
    | t_byte {  // pid=30
        std::cerr << "Use production: basic_type -> byte" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_byte
        , tree::T_BASIC_TYPE);
    }
    | t_double {  // pid=30
        std::cerr << "Use production: basic_type -> double" << std::endl;
        $$ = tools::reduce({$1}, tree::basic_type__T__t_double
        , tree::T_BASIC_TYPE);
    }
    ;
    
period : num t_dot num {  // pid=29
        std::cerr << "Use production: period -> num . num" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::period__T__num__t_dot__num
        , tree::T_PERIOD);
    }
    | period comma num t_dot num {  // pid=30
        std::cerr << "Use production: period -> period , num . num" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::period__T__period__comma__num__t_dot__num
        , tree::T_PERIOD);
    }
    ;

subprogram_declarations : subprogram semicolon {  // pid=31
        std::cerr << "Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::subprogram_declarations__T__subprogram__semicolon
        , tree::T_SUBPROGRAM_DECLARATIONS);
    } 
    | subprogram_declarations subprogram semicolon {  // pid=32
        std::cerr << "Use production: subprogram_declarations -> subprogram_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::subprogram_declarations__T__subprogram_declarations__subprogram__semicolon
        , tree::T_SUBPROGRAM_DECLARATIONS);
    }
    ;

subprogram : subprogram_head semicolon subprogram_body {  // pid=33
        std::cerr << "Use production: subprogram -> subprogram_head ; subprogram_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::subprogram__T__subprogram_head__semicolon__subprogram_body
        , tree::T_SUBPROGRAM);
    }
    ;

subprogram_head : 
      t_function id formal_parameter colon basic_type {  // pid=34
        std::cerr << "Use production: subprogram_head -> function id formal_parameter : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id formal_parameter {  // pid=35
        std::cerr << "Use production: subprogram_head -> procedure id formal_parameter" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::subprogram_head__T__t_procedure__id__formal_parameter
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_function id colon basic_type {  // pid=36
        std::cerr << "Use production: subprogram_head -> function id : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::subprogram_head__T__t_function__id__colon__basic_type
        , tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id {  // pid=37
        std::cerr << "Use production: subprogram_head -> procedure id" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::subprogram_head__T__t_procedure__id
        , tree::T_SUBPROGRAM_HEAD);
    };

formal_parameter : leftparen parameter_list rightparen {  // pid=38
        std::cerr << "Use production: formal_parameter -> ( parameter_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::formal_parameter__T__leftparen__parameter_list__rightparen
        , tree::T_FORMAL_PARAMETER);
    };

parameter_list : parameter {  // pid=39
        std::cerr << "Use production: parameter_list -> parameter" << std::endl;
        $$ = tools::reduce({$1}, tree::parameter_list__T__parameter
        , tree::T_PARAMETER_LIST);
    }
    | parameter_list semicolon parameter {  // pid=40
        std::cerr << "Use production: parameter_list -> parameter_list ; parameter" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::parameter_list__T__parameter_list__semicolon__parameter
        , tree::T_PARAMETER_LIST);
    }
    ;

parameter :  var_parameter {  // pid=41
        std::cerr << "Use production: parameter -> var_parameter" << std::endl;
        $$ = tools::reduce({$1}, tree::parameter__T__var_parameter
        , tree::T_PARAMETER);
    }
    | value_parameter {  // pid=42
        std::cerr << "Use production: parameter -> value_parameter" << std::endl;
        $$ = tools::reduce({$1}, tree::parameter__T__value_parameter
        , tree::T_PARAMETER);
    };

var_parameter : t_var value_parameter {  // pid=43
        std::cerr << "Use production: var_parameter -> var value_parameter" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::var_parameter__T__t_var__value_parameter
        , tree::T_VAR_PARAMETER);
    };
    
value_parameter : idlist colon basic_type {  // pid=44
        std::cerr << "Use production: value_parameter -> idlist : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::value_parameter__T__idlist__colon__basic_type
        , tree::T_VALUE_PARAMETER);
    };

subprogram_body : compound_statement {  // pid=45
        std::cerr << "Use production: subprogram_body -> compound_statement" << std::endl;
        $$ = tools::reduce({$1}, tree::subprogram_body__T__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations compound_statement {  // pid=46
        std::cerr << "Use production: subprogram_body -> const_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::subprogram_body__T__const_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | var_declarations compound_statement{    // pid=47
        std::cerr << "Use production: subprogram_body -> var_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::subprogram_body__T__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations var_declarations compound_statement{
        std::cerr << "Use production: subprogram_body -> const_declarations var_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::subprogram_body__T__const_declarations__var_declarations__compound_statement
        , tree::T_SUBPROGRAM_BODY);
    }
    ;

compound_statement : t_begin statement_list t_end {  // pid=48
        std::cerr << "Use production: compound_statement -> begin statement_list end" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::compound_statement__T__t_begin__statement_list__t_end
        , tree::T_COMPOUND_STATEMENT);
    }
    | t_begin t_end{    // pid=49
        std::cerr << "Use production: compound_statement -> begin end" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::compound_statement__T__t_begin__t_end
        , tree::T_COMPOUND_STATEMENT);
    }

statement_list : statement {  // pid=50
        std::cerr << "Use production: statement_list -> statement" << std::endl;
        $$ = tools::reduce({$1}, tree::statement_list__T__statement, tree::T_STATEMENT_LIST);
    }| statement_list semicolon statement {  // pid=51
        std::cerr << "Use production: statement_list -> statement_list ; statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::statement_list__T__statement_list__semicolon__statement
        , tree::T_STATEMENT_LIST);
    };

statement : variable assignop expression {  // pid=52
        std::cerr << "Use production: statement -> variable assignop expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::statement__T__variable__assignop__expression
        , tree::T_STATEMENT);
    }
    | procedure_call {  // pid=54
        std::cerr << "Use production: statement -> procedure_call" << std::endl;
        $$ = tools::reduce({$1}, tree::statement__T__procedure_call
        , tree::T_STATEMENT);
    }
    | compound_statement {  // pid=55
        std::cerr << "Use production: statement -> compound_statement" << std::endl;
        $$ = tools::reduce({$1}, tree::statement__T__compound_statement
        , tree::T_STATEMENT);
    }  
    // 54 to do
    | t_if expression t_then statement {  // pid=56
        std::cerr << "Use production: statement -> if expression then statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_if__expression__t_then__statement
        , tree::T_STATEMENT);
    }
    | t_if expression t_then statement else_part  {  // pid=56
        std::cerr << "Use production: statement -> if expression then statement else_part" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, tree::statement__T__t_if__expression__t_then__statement__else_part
        , tree::T_STATEMENT);
    }
    | t_while expression t_do statement_list {  // pid=57
        std::cerr << "Use production: statement -> while expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_while__T__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_repeat statement_list t_until expression {  // pid=58
        std::cerr << "Use production: statement -> repeat statement_list until expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_repeat__statement_list__t_until__expression
        , tree::T_STATEMENT);
    }
    | t_for id assignop expression t_to expression t_do statement_list {  // pid=59
        std::cerr << "Use production: statement -> for id assignop expression to expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7}, tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_for id assignop expression t_downto expression t_do statement_list {  // pid=60
        std::cerr << "Use production: statement -> for id assignop expression downto expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7}, tree::statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__statement
        , tree::T_STATEMENT);
    }
    | t_read leftparen variable_list rightparen {  // pid=61
        std::cerr << "Use production: statement -> read ( idlist )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_read__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_readln leftparen variable_list rightparen {  // pid=61
        std::cerr << "Use production: statement -> readln ( idlist )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_readln__leftparen__variable_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_write leftparen expression_list rightparen {  // pid=62
        std::cerr << "Use production: statement -> write ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_write__leftparen__expression_list__rightparen
        , tree::T_STATEMENT);
    }
    | t_writeln leftparen expression_list rightparen {  // pid=62
        std::cerr << "Use production: statement -> writeln ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::statement__T__t_writeln__leftparen__expression_list__rightparen
        , tree::T_STATEMENT);
    }
    ;

variable_list : variable {  // pid=63
        std::cerr << "Use production: variable_list -> variable" << std::endl;
        $$ = tools::reduce({$1}, tree::variable_list__T__variable
        , tree::T_VARIABLE_LIST);
    }
    | variable_list comma variable {  // pid=64
        std::cerr << "Use production: variable_list -> variable_list , variable" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::variable_list__T__variable_list__comma__variable
        , tree::T_VARIABLE_LIST);
    }
    ;

variable : id {  // pid=65
        std::cerr << "Use production: variable -> id" << std::endl;
        $$ = tools::reduce({$1}, tree::variable__T__id
        , tree::T_VARIABLE);
    }
    | id id_varpart {  // pid=66
        std::cerr << "Use production: variable -> id id_varpart" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::variable__T__id__id_varpart
        , tree::T_VARIABLE);
    };

id_varpart : leftbracket expression_list rightbracket {  // pid=67
        std::cerr << "Use production: id_varpart -> [ expression ]" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::id_varpart__T__leftbracket__expression_list__rightbracket
        , tree::T_ID_VARPART);
    }

procedure_call : id leftparen expression_list rightparen {  // pid=68
        std::cerr << "Use production: procedure_call -> id ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::procedure_call__T__id__leftparen__expression_list__rightparen
        , tree::T_PROCEDURE_CALL);
    }
    | id { // pid=69
        std::cerr << "Use production: procedure_call -> id" << std::endl;
        $$ = tools::reduce({$1}, tree::procedure_call__T__id
        , tree::T_PROCEDURE_CALL);
    };

else_part : t_else statement {  // pid=70
        std::cerr << "Use production: else_part -> else statement" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::else_part__T__t_else__statement
        , tree::T_ELSE_PART);
    }
    | t_else  {  // pid = 71
        $$ = tools::reduce({$1}, tree::else_part__T__t_else
        , tree::T_ELSE_PART);
    };

expression_list : expression_list comma expression {  // pid=72
        std::cerr << "Use production: expression_list -> expression_list , expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::expression_list__T__expression_list__comma__expression
        , tree::T_EXPRESSION_LIST);
    }
    |expression {   // pid=73
        std::cerr << "Use production: expression_list -> expression" << std::endl;
        $$ = tools::reduce({$1}, tree::expression_list__T__expression
        , tree::T_EXPRESSION_LIST);
    };

expression : simple_expression {  // pid=74
        std::cerr << "Use production: expression -> simple_expression" << std::endl;
        $$ = tools::reduce({$1}, tree::expression__T__simple_expression
        , tree::T_EXPRESSION);
    }
    | simple_expression relop simple_expression {  // pid=75
        std::cerr << "Use production: expression -> simple_expression relop simple_expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::expression__T__simple_expression__relop__simple_expression
        , tree::T_EXPRESSION);
    }
    | simple_expression equalop simple_expression {  // pid=76
        std::cerr << "Use production: expression -> simple_expression = simple_expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::expression__T__simple_expression__equalop__simple_expression
        , tree::T_EXPRESSION);
    };

simple_expression : term {  // pid=77
        std::cerr << "Use production: simple_expression -> term" << std::endl;
        $$ = tools::reduce({$1}, tree::simple_expression__T__term
        , tree::T_SIMPLE_EXPRESSION);
    }
    | simple_expression addop term {  // pid=78
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::simple_expression__T__term__addop__term
        , tree::T_SIMPLE_EXPRESSION);
    }
    | simple_expression subop term {  // pid=79
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::simple_expression__T__term__subop__term
        , tree::T_SIMPLE_EXPRESSION);
    }
    | simple_expression or_op term {  // pid=80
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::simple_expression__T__term__or_op__term
        , tree::T_SIMPLE_EXPRESSION);
    }
    | literal_string{
        std::cerr << "Use production: simple_expression -> literal_string" << std::endl;
        $$ = tools::reduce({$1}, tree::simple_expression__T__literal_string
        , tree::T_SIMPLE_EXPRESSION);
    }
    | literal_char{
        std::cerr << "Use production: simple_expression -> literal_char" << std::endl;
        $$ = tools::reduce({$1}, tree::simple_expression__T__literal_char
        , tree::T_SIMPLE_EXPRESSION);
    };

term : factor {  // pid=81
        std::cerr << "Use production: term -> factor" << std::endl;
        $$ = tools::reduce({$1}, tree::term__T__factor
        , tree::T_TERM);
    }
    | term mulop factor {  // pid=82
        std::cerr << "Use production: term -> term mulop factor" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::term__T__term__mulop__factor
        , tree::T_TERM);
    }

factor : leftparen expression rightparen {  // pid=83
        std::cerr << "Use production: factor -> ( expression )" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, tree::factor__T__leftparen__expression__rightparen
        , tree::T_FACTOR);
    }
    | variable {  // pid=84
        std::cerr << "Use production: factor -> variable" << std::endl;
        $$ = tools::reduce({$1}, tree::factor__T__variable
        , tree::T_FACTOR);
    }
    | id leftparen expression_list rightparen {  // pid=85
        std::cerr << "Use production: factor -> id ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, tree::factor__T__id__leftparen__expression_list__rightparen
        , tree::T_FACTOR);
    }
    | num { // pid=86
        std::cerr << "Use production: factor -> num" << std::endl;
        $$ = tools::reduce({$1}, tree::factor__T__num
        , tree::T_FACTOR);
    }
    | double_value {
        std::cerr << "Use production: factor -> double_value" << std::endl;
        $$ = tools::reduce({$1}, tree::factor__T__double_value
        , tree::T_FACTOR);
    }
    | notop factor {  // pid=87
        std::cerr << "Use production: factor -> notop factor" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::factor__T__notop__factor
        , tree::T_FACTOR);
    }
    | subop factor {  // pid=88
        std::cerr << "Use production: factor -> - factor" << std::endl;
        $$ = tools::reduce({$1, $2}, tree::factor__T__subop__factor
        , tree::T_FACTOR);
    }
    | bool_value{
        std::cerr << "Use production: factor -> bool_value" << std::endl;
        $$ = tools::reduce({$1}, tree::factor__T__bool_value
        , tree::T_FACTOR);
    };

%%

/* Error log, should not be modified at present */
void yyerror(char *s) {
    if (strlen(yytext) == 0) {
        std::cerr << "Error: " << "end of file: " << "missing operand or block end" << std::endl;
    } else {
        std::cerr << "Error: " << std::string(s) << " at line: " << yylineno << ", encountering unexpected word " << yytext << std::endl;
    }
}