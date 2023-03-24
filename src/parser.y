%{
    #include <iostream>
    #include <string.h>
    
    #include "stack.h"
    #include "tools.h"

    int yylex();
    extern int yylineno;
    extern char *yytext;
    void yyerror(char *s);
%}

%start programstruct
%token num
%token id
%token keyword
%token addop mulop relop
%token seperator
%token assignop
%token literal

%token t_program
%token t_const
%token t_var
%token t_begin
%token t_end
%token t_if
%token t_then
%token t_else
%token t_for
%token t_to
%token t_do
%token t_read
%token t_write
%token t_array
%token t_of
%token t_procedure
%token t_function
%token t_integer
%token t_real
%token t_boolean
%token t_char
%token t_dot
%token t_downto
%token t_while
%token t_repeat
%token t_until
%token t_case
%token or_op
%token notop

%type programstruct program_head program_body
%type const_declarations const_declaration
%type var_declarations var_declaration
%type idlist const_value
%type type basic_type period formal_parameter value_parameter var_parameter
%type subprogram_declarations subprogram subprogram_head subprogram_body
%type parameter parameter_list
%type compound_statement
%type optional_statements statement_list statement
%type procedure_call
%type else_part
%type variable
%type id_varpart expression_list
%type expression simple_expression term factor case_expression_list


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
programstruct : program_head ';' program_body '.' { std::cerr << "Use production: programstruct -> program_head ; program_body ." << std::endl; stack::reduce(4,tree::T_PROGRAM_STRUCT);}
    | error program_head ';' program_body{ 
        // we fix the lack of '.' at the end of the program'
        std::cerr << "error on programstruct fixed" << std::endl; yyerrok; 
        stack::push_temp(3);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[2]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(3, tree::T_PROGRAM_STRUCT);
        }
    ;
program_head : t_program id '(' idlist ')' { std::cerr << "Use production: program_head -> program id ( idlist )" << std::endl; stack::reduce(5,tree::T_PROGRAM_HEAD);}
    | t_program id { std::cerr << "Use production: program_head -> program id" << std::endl; stack::reduce(2,tree::T_PROGRAM_HEAD);}
    | error id '(' idlist ')' { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        stack::push_temp(4);
        stack::clear_error();
        stack::push_token(tree::T_KEYWORD);
        stack::push_tree(stack::temp_stack[3]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(5, tree::T_PROGRAM_HEAD);
        }
    | error id { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        stack::push_temp(1);
        stack::clear_error();
        stack::push_token(tree::T_KEYWORD);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(2, tree::T_PROGRAM_HEAD);
        }
    ;


program_body : const_declarations var_declarations subprogram_declarations compound_statement { std::cerr << "Use production: program_body -> const_declarations var_declarations subprogram_declarations compound_statement" << std::endl; stack::reduce(4,tree::T_PROGRAM_BODY);}
    | const_declarations var_declarations compound_statement { std::cerr << "Use production: program_body -> const_declarations var_declarations compound_statement" << std::endl; stack::reduce(3,tree::T_PROGRAM_BODY);}
    | const_declarations subprogram_declarations compound_statement { std::cerr << "Use production: program_body -> const_declarations subprogram_declarations compound_statement" << std::endl; stack::reduce(3,tree::T_PROGRAM_BODY);}
    | var_declarations subprogram_declarations compound_statement { std::cerr << "Use production: program_body -> var_declarations subprogram_declarations compound_statement" << std::endl; stack::reduce(3,tree::T_PROGRAM_BODY);}
    | const_declarations compound_statement { std::cerr << "Use production: program_body -> const_declarations compound_statement" << std::endl; stack::reduce(2,tree::T_PROGRAM_BODY);}
    | var_declarations compound_statement { std::cerr << "Use production: program_body -> var_declarations compound_statement" << std::endl; stack::reduce(2,tree::T_PROGRAM_BODY);}
    | subprogram_declarations compound_statement { std::cerr << "Use production: program_body -> subprogram_declarations compound_statement" << std::endl; stack::reduce(2,tree::T_PROGRAM_BODY);}
    | compound_statement { std::cerr << "Use production: program_body -> compound_statement" << std::endl; stack::reduce(1,tree::T_PROGRAM_BODY);}
    ;

idlist : id { std::cerr << "Use production: idlist -> id" << std::endl; stack::reduce(1,tree::T_IDLIST);}
    | idlist ',' id { std::cerr << "Use production: idlist -> idlist , id" << std::endl; stack::reduce(3,tree::T_IDLIST);}
    | error idlist id { 
        // we fix the lack of ',' at the end of the idlist'
        std::cerr << "error on idlist fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_IDLIST);
        }
    ;

const_declarations :
    t_const const_declaration ';' { std::cerr << "Use production: const_declarations -> const const_declaration ;" << std::endl; stack::reduce(3,tree::T_CONST_DECLARATIONS);}
    | error const_declaration ';' { 
        // we fix the lack of 'const' at the beginning of the const_declarations'
        std::cerr << "error on const_declarations fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_token(tree::T_KEYWORD);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(3, tree::T_CONST_DECLARATIONS);
        }

const_declaration : id '=' const_value { std::cerr << "Use production: const_declaration -> id = constant" << std::endl; stack::reduce(3,tree::T_CONST_DECLARATION);}
    | const_declaration ';' id '=' const_value { std::cerr << "Use production: const_declaration -> const_declaration , id = constant" << std::endl; stack::reduce(5,tree::T_CONST_DECLARATION);}
    | error const_declaration id '=' const_value { 
        // we fix the lack of ';' at the end of the const_declaration'
        std::cerr << "error on const_declaration fixed" << std::endl; yyerrok; 
        stack::push_temp(4);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[3]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[2]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_token(tree::T_CONST_DECLARATION);
        stack::reduce(5, tree::T_CONST_DECLARATION);
        }
    ;

const_value : num { std::cerr << "Use production: const_value -> num" << std::endl; stack::reduce(1,tree::T_CONST);}
    | '+' num { std::cerr << "Use production: const_value -> + num" << std::endl; stack::reduce(2,tree::T_CONST);}
    | '-' num { std::cerr << "Use production: const_value -> - num" << std::endl; stack::reduce(2,tree::T_CONST);}
    | literal { std::cerr << "Use production: const_value -> literal" << std::endl; stack::reduce(1,tree::T_CONST);}
    ;
    // to do 

var_declarations :
    t_var var_declaration ';' { std::cerr << "Use production: var_declarations -> var var_declaration ;" << std::endl;
    stack::print_ast_stack();
    stack::reduce(3,tree::T_VAR_DECLARATIONS);
    stack::print_ast_stack();
    }
    | error var_declaration ';' { 
        // we fix the lack of 'var' at the beginning of the var_declarations'
        std::cerr << "error on var_declarations fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_token(tree::T_KEYWORD);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(3, tree::T_VAR_DECLARATIONS);
        }
    ;

var_declaration : idlist ':' type { std::cerr << "Use production: var_declaration -> idlist : type" << std::endl; stack::reduce(3,tree::T_VAR_DECLARATION);}
    | var_declaration ';' idlist ':' type { std::cerr << "Use production: var_declaration -> var_declaration ; idlist : type" << std::endl; stack::reduce(5,tree::T_VAR_DECLARATION);}
    | error idlist type { 
        // we fix the lack of ':'
        std::cerr << "error on var_declaration fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_VAR_DECLARATION);
        }
    ;

type : basic_type { std::cerr << "Use production: type -> basic_type" << std::endl; stack::reduce(1,tree::T_TYPE);}
    | t_array '[' period ']' t_of basic_type { std::cerr << "Use production: type -> array [ period ] of basic_type" << std::endl; stack::reduce(6,tree::T_TYPE);}
    | error t_array '[' period ']' basic_type { 
        // we fix the lack of 'of' 
        std::cerr << "error on type fixed" << std::endl; yyerrok; 
        stack::push_temp(5);
        stack::clear_error();
        stack::push_token(tree::T_ARRAY);   // ?
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[4]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_token(tree::T_BASIC_TYPE);
        stack::reduce(5, tree::T_TYPE);
        }
    ;

basic_type : t_integer { std::cerr << "Use production: basic_type -> integer" << std::endl; stack::reduce(1,tree::T_BASIC_TYPE);}
    | t_char { std::cerr << "Use production: basic_type -> char" << std::endl; stack::reduce(1,tree::T_BASIC_TYPE);}
    | t_boolean { std::cerr << "Use production: basic_type -> boolean" << std::endl; stack::reduce(1,tree::T_BASIC_TYPE);}
    | t_real { std::cerr << "Use production: basic_type -> real" << std::endl; stack::reduce(1,tree::T_BASIC_TYPE);}
    ;

period : num t_dot num { std::cerr << "Use production: period -> num .. num" << std::endl; stack::reduce(3,tree::T_PERIOD);}
    | period ',' num t_dot num { std::cerr << "Use production: period -> period , num .. num" << std::endl; stack::reduce(5,tree::T_PERIOD);}
    | error num t_dot { 
        // we fix the lack of num at the end of the period
        std::cerr << "error on period fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        int num = tools::convertStringToNumber(stack::temp_stack.back().get_root()->get_text());
        stack::push_token(tree::T_NUM, tools::intToString(num));
        stack::push_token(tree::T_PERIOD);
        stack::push_token(tree::T_NUM, tools::intToString(num+10));
        stack::reduce(3, tree::T_PERIOD);
        }
    ;

subprogram_declarations :
      subprogram ';' { std::cerr << "Use production: subprogram_declarations -> subprogram_declaration ;" << std::endl; stack::reduce(2,tree::T_SUBPROGRAM_DECLARATIONS);}
    | subprogram_declarations subprogram ';' { std::cerr << "Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;" << std::endl; stack::reduce(3,tree::T_SUBPROGRAM_DECLARATIONS);}
    | error subprogram{
        // we fix the lack of ';' at the end of the subprogram_declaration
        std::cerr << "error on subprogram_declarations fixed" << std::endl; yyerrok; 
        stack::push_temp(1);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[0]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(2, tree::T_SUBPROGRAM_DECLARATIONS);
        }
    ;

subprogram : subprogram_head ';' subprogram_body { std::cerr << "Use production: subprogram -> subprogram_head ; subprogram_body" << std::endl; stack::reduce(3,tree::T_SUBPROGRAM);}
    | error subprogram_head subprogram_body { 
        // we fix the lack of ';' at the end of the subprogram_head
        std::cerr << "error on subprogram fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_SUBPROGRAM);
        }
    ;

subprogram_head : subprogram_head ';' subprogram_body { std::cerr << "Use production: subprogram_head -> subprogram_head ; subprogram_body" << std::endl; stack::reduce(3,tree::T_SUBPROGRAM_HEAD);}
    | t_function id formal_parameter ':' basic_type { std::cerr << "Use production: subprogram_head -> function id formal_parameter : basic_type" << std::endl; stack::reduce(5,tree::T_SUBPROGRAM_HEAD);}
    | t_procedure id formal_parameter { std::cerr << "Use production: subprogram_head -> procedure id ( parameters )" << std::endl; stack::reduce(3,tree::T_SUBPROGRAM_HEAD);}
    | t_function id ':' basic_type { std::cerr << "Use production: subprogram_head -> function id : basic_type" << std::endl; stack::reduce(4,tree::T_SUBPROGRAM_HEAD);}
    | t_procedure id { std::cerr << "Use production: subprogram_head -> procedure id" << std::endl; stack::reduce(2,tree::T_SUBPROGRAM_HEAD);}
    | error id formal_parameter ':' basic_type { 
        // we fix the lack of 'function' at the beginning of the subprogram_head
        std::cerr << "error on subprogram_head fixed" << std::endl; yyerrok; 
        stack::push_temp(4);
        stack::clear_error();
        stack::push_token(tree::T_FUNCTION);
        stack::push_tree(stack::temp_stack[3]);
        stack::push_tree(stack::temp_stack[2]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(5, tree::T_SUBPROGRAM_HEAD);
        }

    | error id formal_parameter {
        // we fix the lack of 'procedure' at the beginning of the subprogram_head
        std::cerr << "error on subprogram_head fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_token(tree::T_PROCEDURE);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_SUBPROGRAM_HEAD);
        }
    ;

formal_parameter : 
    '(' parameter_list ')' { std::cerr << "Use production: formal_parameter -> ( parameter_list )" << std::endl; stack::reduce(3,tree::T_FORMAL_PARAMETER);}
    | error parameter_list ')' { 
        // we fix the lack of '(' at the end of the formal_parameter
        std::cerr << "error on formal_parameter fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(3, tree::T_FORMAL_PARAMETER);
        }
    ;
    
parameter_list : parameter { std::cerr << "Use production: parameter_list -> parameter" << std::endl; stack::reduce(1,tree::T_PARAMETER_LIST);}
    | parameter_list ';' parameter { std::cerr << "Use production: parameter_list -> parameter_list ; parameter" << std::endl; stack::reduce(3,tree::T_PARAMETER_LIST);}
    | error parameter_list parameter { 
        // we fix the lack of ';' at the end of the parameter_list
        std::cerr << "error on parameter_list fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_PARAMETER_LIST);
        }
    ;

parameter : var_parameter { std::cerr << "Use production: parameter -> var_parameter" << std::endl; stack::reduce(1,tree::T_PARAMETER);}
    | value_parameter { std::cerr << "Use production: parameter -> value_parameter" << std::endl; stack::reduce(1,tree::T_PARAMETER);}
    ;

var_parameter : t_var value_parameter { std::cerr << "Use production: var_parameter -> var value_parameter" << std::endl; stack::reduce(2,tree::T_VAR_PARAMETER);}
    ;

value_parameter : idlist ':' basic_type { std::cerr << "Use production: value_parameter -> id_list : basic_type" << std::endl; stack::reduce(3,tree::T_VALUE_PARAMETER);}
    | error idlist basic_type { 
        // we fix the lack of ':' at the end of the value_parameter
        std::cerr << "error on value_parameter fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_VALUE_PARAMETER);
        } 
    ;

subprogram_body : compound_statement { std::cerr << "Use production: subprogram_body -> compound_statement" << std::endl; stack::reduce(1,tree::T_SUBPROGRAM_BODY);}
    | const_declarations { std::cerr << "Use production: subprogram_body -> const_declarations" << std::endl; stack::reduce(1,tree::T_SUBPROGRAM_BODY);}
    | var_declarations { std::cerr << "Use production: subprogram_body -> var_declarations" << std::endl; stack::reduce(1,tree::T_SUBPROGRAM_BODY);}

compound_statement : t_begin statement_list t_end { std::cerr << "Use production: compound_statement -> begin statement_list end" << std::endl; stack::reduce(3,tree::T_COMPOUND_STATEMENT);}
    | t_begin t_end { std::cerr << "Use production: compound_statement -> begin end" << std::endl; stack::reduce(2,tree::T_COMPOUND_STATEMENT);}
    | error statement_list t_end { 
        // we fix the lack of 'begin' at the beginning of the compound_statement
        std::cerr << "error on compound_statement fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_token(tree::T_BEGIN);
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_END);
        stack::reduce(3, tree::T_COMPOUND_STATEMENT);
        }
    ;

statement_list : statement { std::cerr << "Use production: statement_list -> statement" << std::endl; stack::reduce(1,tree::T_STATEMENT_LIST);}
    | statement_list ';' statement{ std::cerr << "Use production: statement_list -> statement_list ; statement" << std::endl; stack::reduce(3,tree::T_STATEMENT_LIST);}
    | error statement_list statement { 
        // we fix the lack of ';' at the end of the statement_list
        std::cerr << "error on statement_list fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR);
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_STATEMENT_LIST);
        }
    ;

statement : variable assignop expression { std::cerr << "Use production: statement -> variable := expression" << std::endl; stack::reduce(3,tree::T_STATEMENT);}
    | id assignop expression { std::cerr << "Use production: statement -> id := expression" << std::endl; stack::reduce(3,tree::T_STATEMENT);}
    | procedure_call
    | compound_statement { std::cerr << "Use production: statement -> compound_statement" << std::endl; stack::reduce(1,tree::T_STATEMENT);}
    | t_if expression t_then statement else_part { std::cerr << "Use production: statement -> if expression then statement else_part" << std::endl; stack::reduce(5,tree::T_STATEMENT);}
    | t_if expression t_then statement { std::cerr << "Use production: statement -> if expression then statement" << std::endl; stack::reduce(4,tree::T_STATEMENT);}
    // to do 
    | t_while expression t_do statement { std::cerr << "Use production: statement -> while expression do statement" << std::endl; stack::reduce(4,tree::T_STATEMENT);}
    | t_for id assignop expression t_to expression t_do statement { std::cerr << "Use production: statement -> for id := expression to expression do statement" << std::endl; stack::reduce(8,tree::T_STATEMENT);}
    | t_for id assignop expression t_downto expression t_to statement { std::cerr << "Use production: statement -> for id := expression downto expression do statement" << std::endl; stack::reduce(8,tree::T_STATEMENT);}
    /* | "repeat" statement_list "until" expression { std::cerr << "Use production: statement -> repeat statement_list until expression" << std::endl; stack::reduce(4,tree::T_STATEMENT);} */
    // to do
    /* | "case" expression "of" case_expression_list "end" { std::cerr << "Use production: statement -> case expression of case_expression_list end" << std::endl; stack::reduce(5,tree::T_STATEMENT);} */
    | t_read '(' idlist ')' { std::cerr << "Use production: statement -> read ( idlist )" << std::endl; stack::reduce(4,tree::T_STATEMENT);}
    | t_write '(' expression_list ')' { std:: cerr << "Use production: statement -> write ( expression_list )" << std::endl; stack::reduce(4,tree::T_STATEMENT);}
    /* | "writeln" '(' expression_list ')' { std:: cerr << "Use production: statement -> writeln ( expression_list )" << std::endl; stack::reduce(4,tree::T_STATEMENT);} */
    | error expression { 
        // we fix the lack of ';' at the end of the statement
        std::cerr << "error on statement fixed" << std::endl; yyerrok; 
        stack::push_temp(1);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[0]);
        stack::push_token(tree::T_SEPERATOR);
        stack::reduce(2, tree::T_STATEMENT);
        }
        ;

variable_list : variable { std::cerr << "Use production: variable_list -> variable" << std::endl; stack::reduce(1,tree::T_VARIABLE_LIST);}
    | variable_list ',' variable { std::cerr << "Use production: variable_list -> variable_list , variable" << std::endl; stack::reduce(3,tree::T_VARIABLE_LIST);}
    | error variable_list variable { 
        // we fix the lack of ',' at the end of the variable_list
        std::cerr << "error on variable_list fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR); // comma or seperator?
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_VARIABLE_LIST);
        }
        ;

variable : id id_varpart { std::cerr << "Use production: variable -> id id_varpart" << std::endl; stack::reduce(2,tree::T_VARIABLE);}
         | id { std::cerr << "Use production: variable -> id" << std::endl; stack::reduce(1,tree::T_VARIABLE);}

id_varpart : 
      '[' expression_list ']' { std::cerr << "Use production: id_varpart -> [ expression_list ]" << std::endl; stack::reduce(3,tree::T_ID_VARPART);}

procedure_call : id '(' expression_list ')' { std::cerr << "Use production: procedure_call -> id ( expression_list )" << std::endl; stack::reduce(4,tree::T_PROCEDURE_CALL);}
    | id { std::cerr << "Use production: procedure_call -> id" << std::endl; stack::reduce(1,tree::T_PROCEDURE_CALL);}

else_part :
      t_else statement { std::cerr << "Use production: else_part -> else statement" << std::endl; stack::reduce(2,tree::T_ELSE_PART);}
    | t_else  { std::cerr << "Use production: else_part -> else" << std::endl; stack::reduce(1,tree::T_ELSE_PART);}

expression_list : expression { std::cerr << "Use production: expression_list -> expression" << std::endl; stack::reduce(1,tree::T_EXPRESSION_LIST);}
    | expression_list ',' expression { std::cerr << "Use production: expression_list -> expression_list , expression" << std::endl; stack::reduce(3,tree::T_EXPRESSION_LIST);}
    | error expression_list expression { 
        // we fix the lack of ',' at the end of the expression_list
        std::cerr << "error on expression_list fixed" << std::endl; yyerrok; 
        stack::push_temp(2);
        stack::clear_error();
        stack::push_tree(stack::temp_stack[1]);
        stack::push_token(tree::T_SEPERATOR); // comma or seperator?
        stack::push_tree(stack::temp_stack[0]);
        stack::reduce(3, tree::T_EXPRESSION_LIST);
        }
        ;

expression : simple_expression { std::cerr << "Use production: expression -> simple_expression " << std::endl; stack::reduce(1,tree::T_EXPRESSION);}
    | simple_expression relop simple_expression { std::cerr << "Use production: expression -> simple_expression relop simple_expression" << std::endl; stack::reduce(3,tree::T_EXPRESSION);}
    | simple_expression '=' simple_expression { std::cerr << "Use production: expression -> simple_expression = simple_expression" << std::endl; stack::reduce(3,tree::T_EXPRESSION);}

simple_expression : term { std::cerr << "Use production: simple_expression -> term " << std::endl; stack::reduce(1,tree::T_SIMPLE_EXPRESSION);}
    | term '+' term { std::cerr << "Use production: simple_expression -> term addop term" << std::endl; stack::reduce(3,tree::T_SIMPLE_EXPRESSION);}
    | term '-' term { std::cerr << "Use production: simple_expression -> term addop term" << std::endl; stack::reduce(3,tree::T_SIMPLE_EXPRESSION);}
    | term or_op term { std::cerr << "Use production: simple_expression -> term addop term" << std::endl; stack::reduce(3,tree::T_SIMPLE_EXPRESSION);}
    ;

term : factor { std::cerr << "Use production: term -> factor " << std::endl; stack::reduce(1,tree::T_TERM);}
    | term mulop factor { std::cerr << "Use production: term -> factor mulop factor" << std::endl; stack::reduce(3,tree::T_TERM);}
    ;

    factor : variable { std::cerr << "Use production: factor -> variable" << std::endl; stack::reduce(1,tree::T_FACTOR);}
    | id '(' expression_list ')' { std::cerr << "Use production: factor -> id ( expression_list )" << std::endl; stack::reduce(4,tree::T_FACTOR);}
    | num { std::cerr << "Use production: factor -> number" << std::endl; stack::reduce(1,tree::T_FACTOR);}
    | '(' expression ')' { std::cerr << "Use production: factor -> ( expression )" << std::endl; stack::reduce(3,tree::T_FACTOR);}
    | notop factor { std::cerr << "Use production: factor -> not factor" << std::endl; stack::reduce(2,tree::T_FACTOR);}
    | '-' factor { std::cerr << "Use production: factor -> - factor" << std::endl; stack::reduce(2,tree::T_FACTOR);}
    ;
    

%%

/* Error log, should not be modified at present */
void yyerror(char *s) {
    stack::push_error();
    stack::print_ast_stack();
    if (strlen(yytext) == 0) {
        std::cerr << "Error: " << "end of file: " << "missing operand or block end" << std::endl;
    } else {
        std::cerr << "Error: " << std::string(s) << " at line: " << yylineno << ", encountering unexpected word " << yytext << std::endl;
    }
}