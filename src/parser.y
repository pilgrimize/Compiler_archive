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
%token <token_Tree> t_char
%token <token_Tree> t_dot
%token <token_Tree> t_downto
%token <token_Tree> t_while
%token <token_Tree> t_repeat
%token <token_Tree> t_until
%token <token_Tree> t_case
%token <token_Tree> or_op
%token <token_Tree> notop
%token <token_Tree> float_num

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
        tree::ast = tools::reduce({$1, $2, $3, $4}, P_PROGRAM, tree::T_PROGRAM_STRUCT);
    }
    ;
program_head : t_program id leftparen idlist rightparen { // pid = 2
        std::cerr << "Use production: program_head -> program id ( idlist )" << std::endl; 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 2, tree::T_PROGRAM_HEAD);
        }
    | t_program id { // pid = 3
        std::cerr << "Use production: program_head -> program id" << std::endl; 
        $$ = tools::reduce({$1, $2},3, tree::T_PROGRAM_HEAD);
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
        $$ = tools::reduce({$1, $2, $3, $4}, 4, tree::T_PROGRAM_BODY);

        }
    | const_declarations var_declarations compound_statement { // pid=5
        std::cerr << "Use production: program_body -> const_declarations var_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 5, tree::T_PROGRAM_BODY);
        }
    | const_declarations subprogram_declarations compound_statement { // pid=6
        std::cerr << "Use production: program_body -> const_declarations subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, 6, tree::T_PROGRAM_BODY);
        }
    | var_declarations subprogram_declarations compound_statement { // pid=7
        std::cerr << "Use production: program_body -> var_declarations subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, 7, tree::T_PROGRAM_BODY);
        }
    | const_declarations compound_statement {  // pid=8
        std::cerr << "Use production: program_body -> const_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, 8, tree::T_PROGRAM_BODY);
        }

    | var_declarations compound_statement {  // pid=9
        std::cerr << "Use production: program_body -> var_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, 9, tree::T_PROGRAM_BODY);
    }
    | subprogram_declarations compound_statement {  // pid=10
        std::cerr << "Use production: program_body -> subprogram_declarations compound_statement" << std::endl; 
        $$ = tools::reduce({$1, $2}, 10, tree::T_PROGRAM_BODY);
        }
    | compound_statement {  // pid=11
        std::cerr << "Use production: program_body -> compound_statement" << std::endl; 
        $$ = tools::reduce({$1}, 11, tree::T_PROGRAM_BODY);
        }
    ;

idlist : id {  // pid=12
        std::cerr << "Use production: idlist -> id" << std::endl; 
        $$ = tools::reduce({$1}, 12, tree::T_IDLIST);
        }
    | idlist comma id {  // pid=13
        std::cerr << "Use production: idlist -> idlist , id" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 13, tree::T_IDLIST);
        }
    ;

const_declarations :
    t_const const_declaration semicolon {  // pid=14
        std::cerr << "Use production: const_declarations -> const const_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 14, tree::T_CONST_DECLARATIONS);
        }

const_declaration : id equalop const_value {  // pid=15
        std::cerr << "Use production: const_declaration -> id = constant" << std::endl; 
        $$ = tools::reduce({$1, $2, $3}, 15, tree::T_CONST_DECLARATION);
    }
    | const_declaration semicolon id equalop const_value {  // pid=16
        std::cerr << "Use production: const_declaration -> const_declaration , id = constant" << std::endl; 
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 16, tree::T_CONST_DECLARATION);
        }
    ;

const_value : num {  // pid=17
        std::cerr << "Use production: const_value -> num" << std::endl; 
        $$ = tools::reduce({$1}, 17, tree::T_CONST_VALUE);
        }
    | addop num {  // pid=18
        std::cerr << "Use production: const_value -> + num" << std::endl; 
        $$ = tools::reduce({$1, $2}, 18, tree::T_CONST_VALUE);
        }
    | subop num {  // pid=19
        std::cerr << "Use production: const_value -> - num" << std::endl; 
        $$ = tools::reduce({$1, $2}, 19, tree::T_CONST_VALUE);
        }
    | literal {  // pid=20
        std::cerr << "Use production: const_value -> literal" << std::endl; 
        $$ = tools::reduce({$1}, 20, tree::T_CONST_VALUE);
        }
    ;
    // to do 

var_declarations :
    t_var var_declaration semicolon {  // pid=21
        std::cerr << "Use production: var_declarations -> var var_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 21, tree::T_VAR_DECLARATIONS);
    }
    ;

var_declaration : idlist colon type {  // pid=22
        std::cerr << "Use production: var_declaration -> id_list : type" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 22, tree::T_VAR_DECLARATION);
    }
    | var_declaration semicolon idlist colon type {  // pid=23
        std::cerr << "Use production: var_declaration -> var_declaration ; id_list : type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 23, tree::T_VAR_DECLARATION);
    }
    ;

type : basic_type {  // pid=24
        std::cerr << "Use production: type -> basic_type" << std::endl;
        $$ = tools::reduce({$1}, 24, tree::T_TYPE);
    }
    | t_array leftbracket period rightbracket t_of basic_type {  // pid=25
        std::cerr << "Use production: type -> array [ num ] of basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6}, 25, tree::T_TYPE);
    }
    ;
    
basic_type : t_integer {  // pid=26
        std::cerr << "Use production: basic_type -> integer" << std::endl;
        $$ = tools::reduce({$1}, 26, tree::T_BASIC_TYPE);
    }
    | t_real {  // pid=27
        std::cerr << "Use production: basic_type -> real" << std::endl;
        $$ = tools::reduce({$1}, 27, tree::T_BASIC_TYPE);
    }
    | t_boolean {  // pid=28
        std::cerr << "Use production: basic_type -> boolean" << std::endl;
        $$ = tools::reduce({$1}, 28, tree::T_BASIC_TYPE);
    }
    ;
    
period : num t_dot num {  // pid=29
        std::cerr << "Use production: period -> num . num" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 29, tree::T_PERIOD);
    }
    |period comma num t_dot num {  // pid=30
        std::cerr << "Use production: period -> period , num . num" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 30, tree::T_PERIOD);
    }
    ;

subprogram_declarations : subprogram semicolon {  // pid=31
        std::cerr << "Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2}, 31, tree::T_SUBPROGRAM_DECLARATIONS);
    } 
    | subprogram_declarations subprogram semicolon {  // pid=32
        std::cerr << "Use production: subprogram_declarations -> subprogram_declaration ;" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 32, tree::T_SUBPROGRAM_DECLARATIONS);
    }
    ;

subprogram : subprogram_head semicolon subprogram_body {  // pid=33
        std::cerr << "Use production: subprogram -> subprogram_head ; subprogram_declarations compound_statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 33, tree::T_SUBPROGRAM);
    }
    ;

subprogram_head : 
      t_function id formal_parameter colon basic_type {  // pid=34
        std::cerr << "Use production: subprogram_head -> function id formal_parameter : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 34, tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id formal_parameter {  // pid=35
        std::cerr << "Use production: subprogram_head -> procedure id formal_parameter" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 35, tree::T_SUBPROGRAM_HEAD);
    }
    | t_function id colon basic_type {  // pid=36
        std::cerr << "Use production: subprogram_head -> function id : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 36, tree::T_SUBPROGRAM_HEAD);
    }
    | t_procedure id {  // pid=37
        std::cerr << "Use production: subprogram_head -> procedure id" << std::endl;
        $$ = tools::reduce({$1, $2}, 37, tree::T_SUBPROGRAM_HEAD);
    }

    formal_parameter : leftparen parameter_list rightparen {  // pid=38
        std::cerr << "Use production: formal_parameter -> ( parameter_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 38, tree::T_FORMAL_PARAMETER);
    }
    ;

parameter_list : parameter {  // pid=39
        std::cerr << "Use production: parameter_list -> parameter" << std::endl;
        $$ = tools::reduce({$1}, 39, tree::T_PARAMETER_LIST);
    }
    | parameter_list semicolon parameter {  // pid=40
        std::cerr << "Use production: parameter_list -> parameter_list ; parameter" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 40, tree::T_PARAMETER_LIST);
    }
    ;

parameter :  var_parameter {  // pid=41
        std::cerr << "Use production: parameter -> var_parameter" << std::endl;
        $$ = tools::reduce({$1}, 41, tree::T_PARAMETER);
    }
    | value_parameter {  // pid=42
        std::cerr << "Use production: parameter -> value_parameter" << std::endl;
        $$ = tools::reduce({$1}, 42, tree::T_PARAMETER);
    };

var_parameter : t_var value_parameter {  // pid=43
        std::cerr << "Use production: var_parameter -> var value_parameter" << std::endl;
        $$ = tools::reduce({$1, $2}, 43, tree::T_VAR_PARAMETER);
    };
    
value_parameter : idlist colon basic_type {  // pid=44
        std::cerr << "Use production: value_parameter -> idlist : basic_type" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 44, tree::T_VALUE_PARAMETER);
    };

subprogram_body : compound_statement {  // pid=45
        std::cerr << "Use production: subprogram_body -> compound_statement" << std::endl;
        $$ = tools::reduce({$1}, 45, tree::T_SUBPROGRAM_BODY);
    }
    | const_declarations {  // pid=46
        std::cerr << "Use production: subprogram_body -> const_declarations" << std::endl;
        $$ = tools::reduce({$1}, 46, tree::T_SUBPROGRAM_BODY);
    }
    | var_declarations {    // pid=47
        std::cerr << "Use production: subprogram_body -> var_declarations" << std::endl;
        $$ = tools::reduce({$1}, 47, tree::T_SUBPROGRAM_BODY);
    }
    ;

compound_statement : t_begin statement_list t_end {  // pid=48
        std::cerr << "Use production: compound_statement -> begin statement_list end" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 48, tree::T_COMPOUND_STATEMENT);
    }
    | t_begin t_end{    // pid=49
        std::cerr << "Use production: compound_statement -> begin end" << std::endl;
        $$ = tools::reduce({$1, $2}, 49, tree::T_COMPOUND_STATEMENT);
    }

statement_list : statement {  // pid=50
        std::cerr << "Use production: statement_list -> statement" << std::endl;
        $$ = tools::reduce({$1}, 50, tree::T_STATEMENT_LIST);
    }| statement_list semicolon statement {  // pid=51
        std::cerr << "Use production: statement_list -> statement_list ; statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 51, tree::T_STATEMENT_LIST);
    };

statement : variable assignop expression {  // pid=52
        std::cerr << "Use production: statement -> variable assignop expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 52, tree::T_STATEMENT);
    }
    | id assignop expression {  // pid=53
        std::cerr << "Use production: statement -> id assignop expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 53, tree::T_STATEMENT);
    }
    | procedure_call {  // pid=54
        std::cerr << "Use production: statement -> procedure_call" << std::endl;
        $$ = tools::reduce({$1}, 54, tree::T_STATEMENT);
    }
    | compound_statement {  // pid=55
        std::cerr << "Use production: statement -> compound_statement" << std::endl;
        $$ = tools::reduce({$1}, 55, tree::T_STATEMENT);
    }  
    // 54 to do
    | t_if expression t_then statement else_part  {  // pid=56
        std::cerr << "Use production: statement -> if expression then statement else statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5}, 56, tree::T_STATEMENT);
    }
    | t_while expression t_do statement {  // pid=57
        std::cerr << "Use production: statement -> while expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 57, tree::T_STATEMENT);
    }
    | t_repeat statement_list t_until expression {  // pid=58
        std::cerr << "Use production: statement -> repeat statement_list until expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 58, tree::T_STATEMENT);
    }
    | t_for id assignop expression t_to expression t_do statement {  // pid=59
        std::cerr << "Use production: statement -> for id assignop expression to expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7}, 59, tree::T_STATEMENT);
    }
    | t_for id assignop expression t_downto expression t_do statement {  // pid=60
        std::cerr << "Use production: statement -> for id assignop expression downto expression do statement" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4, $5, $6, $7}, 60, tree::T_STATEMENT);
    }
    | t_read leftparen variable_list rightparen {  // pid=61
        std::cerr << "Use production: statement -> read ( idlist )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 61, tree::T_STATEMENT);
    }
    | t_write leftparen expression_list rightparen {  // pid=62
        std::cerr << "Use production: statement -> write ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 62, tree::T_STATEMENT);
    }
    ;

variable_list : variable {  // pid=63
        std::cerr << "Use production: variable_list -> variable" << std::endl;
        $$ = tools::reduce({$1}, 63, tree::T_VARIABLE_LIST);
    }
    | variable_list comma variable {  // pid=64
        std::cerr << "Use production: variable_list -> variable_list , variable" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 64, tree::T_VARIABLE_LIST);
    }
    ;

variable : id {  // pid=65
        std::cerr << "Use production: variable -> id" << std::endl;
        $$ = tools::reduce({$1}, 65, tree::T_VARIABLE);
    }
    | id id_varpart {  // pid=66
        std::cerr << "Use production: variable -> id id_varpart" << std::endl;
        $$ = tools::reduce({$1, $2}, 66, tree::T_VARIABLE);
    };

id_varpart : leftbracket expression_list rightbracket {  // pid=67
        std::cerr << "Use production: id_varpart -> [ expression ]" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 67, tree::T_ID_VARPART);
    }

procedure_call : id leftparen expression_list rightparen {  // pid=68
        std::cerr << "Use production: procedure_call -> id ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 68, tree::T_PROCEDURE_CALL);
    }
    | id { // pid=69
        std::cerr << "Use production: procedure_call -> id" << std::endl;
        $$ = tools::reduce({$1}, 69, tree::T_PROCEDURE_CALL);
    };

else_part : t_else statement {  // pid=70
        std::cerr << "Use production: else_part -> else statement" << std::endl;
        $$ = tools::reduce({$1, $2}, 70, tree::T_ELSE_PART);
    }
    | t_else  {  // pid = 71
        $$ = tools::reduce({$1}, 71, tree::T_ELSE_PART);
    };

expression_list : expression_list comma expression {  // pid=72
        std::cerr << "Use production: expression_list -> expression_list , expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 72, tree::T_EXPRESSION_LIST);
    }
    |expression {   // pid=73
        std::cerr << "Use production: expression_list -> expression" << std::endl;
        $$ = tools::reduce({$1}, 73, tree::T_EXPRESSION_LIST);
    };

expression : simple_expression {  // pid=74
        std::cerr << "Use production: expression -> simple_expression" << std::endl;
        $$ = tools::reduce({$1}, 74, tree::T_EXPRESSION);
    }
    | simple_expression relop simple_expression {  // pid=75
        std::cerr << "Use production: expression -> simple_expression relop simple_expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 75, tree::T_EXPRESSION);
    }
    | simple_expression equalop simple_expression {  // pid=76
        std::cerr << "Use production: expression -> simple_expression = simple_expression" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 76, tree::T_EXPRESSION);
    };

simple_expression : term {  // pid=77
        std::cerr << "Use production: simple_expression -> term" << std::endl;
        $$ = tools::reduce({$1}, 77, tree::T_SIMPLE_EXPRESSION);
    }
    | term addop term {  // pid=78
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 78, tree::T_SIMPLE_EXPRESSION);
    }
    | term subop term {  // pid=79
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 79, tree::T_SIMPLE_EXPRESSION);
    }
    | term or_op term {  // pid=80
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 80, tree::T_SIMPLE_EXPRESSION);
    };

term : factor {  // pid=81
        std::cerr << "Use production: term -> factor" << std::endl;
        $$ = tools::reduce({$1}, 81, tree::T_TERM);
    }
    | term mulop factor {  // pid=82
        std::cerr << "Use production: term -> term mulop factor" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 82, tree::T_TERM);
    }

factor : leftparen expression rightparen {  // pid=83
        std::cerr << "Use production: factor -> ( expression )" << std::endl;
        $$ = tools::reduce({$1, $2, $3}, 83, tree::T_FACTOR);
    }
    | variable {  // pid=84
        std::cerr << "Use production: factor -> variable" << std::endl;
        $$ = tools::reduce({$1}, 84, tree::T_FACTOR);
    }
    | id leftparen expression_list rightparen {  // pid=85
        std::cerr << "Use production: factor -> id ( expression_list )" << std::endl;
        $$ = tools::reduce({$1, $2, $3, $4}, 85, tree::T_FACTOR);
    }
    | num { // pid=86
        std::cerr << "Use production: factor -> num" << std::endl;
        $$ = tools::reduce({$1}, 86, tree::T_FACTOR);
    }
    | notop factor {  // pid=87
        std::cerr << "Use production: factor -> notop factor" << std::endl;
        $$ = tools::reduce({$1, $2}, 87, tree::T_FACTOR);
    }
    | subop factor {  // pid=88
        std::cerr << "Use production: factor -> - factor" << std::endl;
        $$ = tools::reduce({$1, $2}, 88, tree::T_FACTOR);
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