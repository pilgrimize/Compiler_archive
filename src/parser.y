%{
    #include <iostream>
    #include <string.h>
    
    // #include "stack.h"
    #include "tools.h"
    #include "tree.h"

    int yylex();
    extern int yylineno;
    extern char *yytext;
    void yyerror(char *s);

%}


%union {
    char* str;
    int num;
    Type_Tree Tree;
}

%start programstruct
%token <str> num
%token <str> id
%token keyword
%token addop mulop relop
%token seperator
%token assignop
%token <str> literal

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

%type <Tree> programstruct program_head program_body
%type <Tree> const_declarations const_declaration
%type <Tree> var_declarations var_declaration
%type <Tree> idlist const_value
%type <Tree> type basic_type period formal_parameter value_parameter var_parameter
%type <Tree> subprogram_declarations subprogram subprogram_head subprogram_body
%type <Tree> parameter parameter_list
%type <Tree> compound_statement
%type <Tree> optional_statements statement_list statement
%type <Tree> procedure_call
%type <Tree> else_part
%type <Tree> variable variable_list
%type <Tree> id_varpart expression_list
%type <Tree> expression simple_expression term factor case_expression_list


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
programstruct : program_head ';' program_body '.' { // pid = 1
        std::cerr << "Use production: programstruct -> program_head ; program_body ." << std::endl; 
        vector<tree::TreeNode> children; 
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_STRUCT, "", children), 1, vid, vnum);
    }
    ;
program_head : t_program id '(' idlist ')' { // pid = 2
        std::cerr << "Use production: program_head -> program id ( idlist )" << std::endl; 
        vector<tree::TreeNode> children; 
        vector<std::string> vid;
        vector<std::string> vnum;

        children.push_back($4->get_root());
        vid.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_HEAD, "", children), 2, vid, vnum);
        }
    | t_program id { // pid = 3
        std::cerr << "Use production: program_head -> program id" << std::endl; 
        vector<tree::TreeNode> children; 
        vector<std::string> vid;
        vector<std::string> vnum;

        vid.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_HEAD, "", children, vid, vnum), 3);
        }
    | error id '(' idlist ')' { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        vector<tree::TreeNode> children; 
        vector<std::string> vid;
        vector<std::string> vnum;

        children.push_back($4->get_root());
        vid.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_HEAD, "", children), 2);
        }
    | error id { 
        // we fix the lack of 'program' at the beginning of the program_head'
        std::cerr << "error on program_head fixed" << std::endl; yyerrok; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;

        vid.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_HEAD, "", children), 3);
        }
    ;


program_body : const_declarations var_declarations subprogram_declarations compound_statement { // pid = 4
        std::cerr << "Use production: program_body -> const_declarations var_declarations subprogram_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        children.push_back($3->get_root());
        children.push_back($4->get_root());

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 4, vid, vnum);

        }
    | const_declarations var_declarations compound_statement { // pid=5
        std::cerr << "Use production: program_body -> const_declarations var_declarations compound_statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        children.push_back($3->get_root());

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 5, vid, vnum);
        }
    | const_declarations subprogram_declarations compound_statement { // pid=6
        std::cerr << "Use production: program_body -> const_declarations subprogram_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        children.push_back($3->get_root());

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 6, vid, vnum);
        }
    | var_declarations subprogram_declarations compound_statement { // pid=7
        std::cerr << "Use production: program_body -> var_declarations subprogram_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        children.push_back($3->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 7, vid, vnum);
        }
    | const_declarations compound_statement {  // pid=8
        std::cerr << "Use production: program_body -> const_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 8, vid, vnum);
        }

    | var_declarations compound_statement {  // pid=9
        std::cerr << "Use production: program_body -> var_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 9, vid, vnum);
    }
    | subprogram_declarations compound_statement {  // pid=10
        std::cerr << "Use production: program_body -> subprogram_declarations compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 10, vid, vnum);
        }
    | compound_statement {  // pid=11
        std::cerr << "Use production: program_body -> compound_statement" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROGRAM_BODY, "", children), 11, vid, vnum);
        }
    ;

idlist : id {  // pid=12
        std::cerr << "Use production: idlist -> id" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_IDLIST, "", children), 12, vid, vnum);
        }
    | idlist ',' id {  // pid=13
        std::cerr << "Use production: idlist -> idlist , id" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        vid.push_back($3);
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_IDLIST, "", children), 13, vid, vnum);
        }
    ;

const_declarations :
    t_const const_declaration ';' {  // pid=14
        std::cerr << "Use production: const_declarations -> const const_declaration ;" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST_DECLARATIONS, "", children), 14, vid, vnum);
        }

const_declaration : id '=' const_value {  // pid=15
        std::cerr << "Use production: const_declaration -> id = constant" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($3->get_root());
        vid.push_back($1);

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST_DECLARATION, "", children), 15, vid, vnum);
    }
    | const_declaration ';' id '=' const_value {  // pid=16
        std::cerr << "Use production: const_declaration -> const_declaration , id = constant" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($5->get_root());
        vid.push_back($3);

        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST_DECLARATION, "", children), 16, vid, vnum);
        }
    ;

const_value : num {  // pid=17
        std::cerr << "Use production: const_value -> num" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vnum.push_back($1);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST, "", children), 17, vid, vnum);
        }
    | '+' num {  // pid=18
        std::cerr << "Use production: const_value -> + num" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vnum.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST, "", children), 18, vid, vnum);
        }
    | '-' num {  // pid=19
        std::cerr << "Use production: const_value -> - num" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vnum.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST, "", children), 19, vid, vnum);
        }
    | literal {  // pid=20
        std::cerr << "Use production: const_value -> literal" << std::endl; 
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vnum.push_back($1);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_CONST, "", children), 20, vid, vnum);
        }
    ;
    // to do 

var_declarations :
    t_var var_declaration ';' {  // pid=21
        std::cerr << "Use production: var_declarations -> var var_declaration ;" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VAR_DECLARATIONS, "", children), 21, vid, vnum);
    }
    ;

var_declaration : idlist ':' type {  // pid=22
        std::cerr << "Use production: var_declaration -> id_list : type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VAR_DECLARATION, "", children), 22, vid, vnum);
    }
    | var_declaration ';' idlist ':' type {  // pid=23
        std::cerr << "Use production: var_declaration -> var_declaration ; id_list : type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        children.push_back($5->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VAR_DECLARATION, "", children), 23, vid, vnum);
    }
    ;

type : basic_type {  // pid=24
        std::cerr << "Use production: type -> basic_type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_TYPE, "", children), 24, vid, vnum);
    }
    | t_array '[' num ']' t_of basic_type {  // pid=25
        std::cerr << "Use production: type -> array [ num ] of basic_type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($6->get_root());
        vnum.push_back($3);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_TYPE, "", children), 25, vid, vnum);
    }
    ;
    
basic_type : t_integer {  // pid=26
        std::cerr << "Use production: basic_type -> integer" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_BASIC_TYPE, "", children), 26, vid, vnum);
    }
    | t_real {  // pid=27
        std::cerr << "Use production: basic_type -> real" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_BASIC_TYPE, "", children), 27, vid, vnum);
    }
    | t_boolean {  // pid=28
        std::cerr << "Use production: basic_type -> boolean" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_BASIC_TYPE, "", children), 28, vid, vnum);
    }
    ;
    
period : num t_dot num {  // pid=29
        std::cerr << "Use production: period -> num . num" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vnum.push_back($1);
        vnum.push_back($3);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PERIOD, "", children), 29, vid, vnum);
    }
    |period ',' num t_dot num {  // pid=30
        std::cerr << "Use production: period -> period , num . num" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        vnum.push_back($3);
        vnum.push_back($5);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PERIOD, "", children), 30, vid, vnum);
    }
    ;

subprogram_declarations : subprogram ';' {  // pid=31
        std::cerr << "Use production: subprogram_declarations -> subprogram_declarations subprogram_declaration ;" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_DECLARATIONS, "", children), 31, vid, vnum);
    } 
    | subprogram_declarations subprogram ';' {  // pid=32
        std::cerr << "Use production: subprogram_declarations -> subprogram_declaration ;" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_DECLARATIONS, "", children), 32, vid, vnum);
    }
    ;

subprogram : subprogram_head ';' subprogram_body {  // pid=33
        std::cerr << "Use production: subprogram -> subprogram_head ; subprogram_declarations compound_statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM, "", children), 33, vid, vnum);
    }
    ;

subprogram_head : subprogram_head ';' subprogram_body {  // pid=34
        std::cerr << "Use production: subprogram_head -> subprogram_head ; subprogram_declarations compound_statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_HEAD, "", children), 34, vid, vnum);
    }
    | t_function id formal_parameter ':' basic_type {  // pid=35
        std::cerr << "Use production: subprogram_head -> function id formal_parameter : basic_type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        children.push_back($3->get_root());
        children.push_back($5->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_HEAD, "", children), 35, vid, vnum);
    }
    | t_procedure id formal_parameter {  // pid=36
        std::cerr << "Use production: subprogram_head -> procedure id formal_parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_HEAD, "", children), 36, vid, vnum);
    }
    | t_function id ':' basic_type {  // pid=37
        std::cerr << "Use production: subprogram_head -> function id : basic_type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        children.push_back($4->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_HEAD, "", children), 37, vid, vnum);
    }
    | t_procedure id {  // pid=38
        std::cerr << "Use production: subprogram_head -> procedure id" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_HEAD, "", children), 38, vid, vnum);
    }

    formal_parameter : '(' parameter_list ')' {  // pid=39
        std::cerr << "Use production: formal_parameter -> ( parameter_list )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FORMAL_PARAMETER, "", children), 39, vid, vnum);
    }
    ;

parameter_list : parameter {  // pid=40
        std::cerr << "Use production: parameter_list -> parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PARAMETER_LIST, "", children), 40, vid, vnum);
    }
    | parameter_list ';' parameter {  // pid=41
        std::cerr << "Use production: parameter_list -> parameter_list ; parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PARAMETER_LIST, "", children), 41, vid, vnum);
    }
    ;

parameter :  var_parameter {  // pid=42
        std::cerr << "Use production: parameter -> var_parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PARAMETER, "", children), 42, vid, vnum);
    }
    | value_parameter {  // pid=43
        std::cerr << "Use production: parameter -> value_parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PARAMETER, "", children), 43, vid, vnum);
    };

var_parameter : t_var value_parameter {  // pid=44
        std::cerr << "Use production: var_parameter -> var value_parameter" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VAR_PARAMETER, "", children), 44, vid, vnum);
    };
    
value_parameter : idlist ':' basic_type {  // pid=45
        std::cerr << "Use production: value_parameter -> idlist : basic_type" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VALUE_PARAMETER, "", children), 45, vid, vnum);
    };

subprogram_body : compound_statement {  // pid=46
        std::cerr << "Use production: subprogram_body -> compound_statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_BODY, "", children), 46, vid, vnum);
    }
    | const_declarations {
        std::cerr << "Use production: subprogram_body -> const_declarations" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_BODY, "", children), 46, vid, vnum);
    }
    | var_declarations {
        std::cerr << "Use production: subprogram_body -> var_declarations" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SUBPROGRAM_BODY, "", children), 46, vid, vnum);
    }
    ;

compound_statement : t_begin statement_list t_end {  // pid=47
        std::cerr << "Use production: compound_statement -> begin statement_list end" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_COMPOUND_STATEMENT, "", children), 47, vid, vnum);
    }
    | t_begin t_end{
        std::cerr << "Use production: compound_statement -> begin end" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_COMPOUND_STATEMENT, "", children), 47, vid, vnum);
    }

statement_list : statement {  // pid=48
        std::cerr << "Use production: statement_list -> statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT_LIST, "", children), 48, vid, vnum);
    }| statement_list ';' statement {  // pid=49
        std::cerr << "Use production: statement_list -> statement_list ; statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT_LIST, "", children), 49, vid, vnum);
    };

statement : variable assignop expression {  // pid=50
        std::cerr << "Use production: statement -> variable assignop expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 50, vid, vnum);
    }
    | id assignop expression {  // pid=51
        std::cerr << "Use production: statement -> id assignop expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 51, vid, vnum);
    }
    | procedure_call {  // pid=52
        std::cerr << "Use production: statement -> procedure_call" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 52, vid, vnum);
    }
    | compound_statement {  // pid=53
        std::cerr << "Use production: statement -> compound_statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 53, vid, vnum);
    }  
    | t_if expression t_then statement {  // pid=54
        std::cerr << "Use production: statement -> if expression then statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        children.push_back($4->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 54, vid, vnum);
    }
    | t_if expression t_then statement t_else statement {  // pid=55
        std::cerr << "Use production: statement -> if expression then statement else statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        children.push_back($4->get_root());
        children.push_back($6->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 55, vid, vnum);
    }
    | t_while expression t_do statement {  // pid=56
        std::cerr << "Use production: statement -> while expression do statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        children.push_back($4->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 56, vid, vnum);
    }
    | t_repeat statement_list t_until expression {  // pid=57
        std::cerr << "Use production: statement -> repeat statement_list until expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        children.push_back($4->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 57, vid, vnum);
    }
    | t_for id assignop expression t_to expression t_do statement {  // pid=58
        std::cerr << "Use production: statement -> for id assignop expression to expression do statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        children.push_back($4->get_root());
        children.push_back($6->get_root());
        children.push_back($8->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 58, vid, vnum);
    }
    | t_for id assignop expression t_downto expression t_do statement {  // pid=59
        std::cerr << "Use production: statement -> for id assignop expression downto expression do statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($2);
        children.push_back($4->get_root());
        children.push_back($6->get_root());
        children.push_back($8->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 59, vid, vnum);
    }
    | t_read '(' variable_list ')' {  // pid=60
        std::cerr << "Use production: statement -> read ( idlist )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 60, vid, vnum);
    }
    | t_write '(' expression_list ')' {  // pid=61
        std::cerr << "Use production: statement -> write ( expression_list )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_STATEMENT, "", children), 61, vid, vnum);
    }
    ;

variable_list : variable {  // pid=62
        std::cerr << "Use production: variable_list -> variable" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VARIABLE_LIST, "", children), 62, vid, vnum);
    }
    | variable_list ',' variable {  // pid=63
        std::cerr << "Use production: variable_list -> variable_list , variable" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VARIABLE_LIST, "", children), 63, vid, vnum);
    }
    ;

variable : id {  // pid=64
        std::cerr << "Use production: variable -> id" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1); 
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VARIABLE, "", children), 64, vid, vnum);
    }
    | id id_varpart {  // pid=65
        std::cerr << "Use production: variable -> id id_varpart" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_VARIABLE, "", children), 65, vid, vnum);
    };

id_varpart : '[' expression ']' {  // pid=66
        std::cerr << "Use production: id_varpart -> [ expression ]" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_ID_VARPART, "", children), 66, vid, vnum);
    }

procedure_call : id '(' expression_list ')' {  // pid=67
        std::cerr << "Use production: procedure_call -> id ( expression_list )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROCEDURE_CALL, "", children), 67, vid, vnum);
    }
    | id { // pid=68
        std::cerr << "Use production: procedure_call -> id" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_PROCEDURE_CALL, "", children), 68, vid, vnum);
    };

else_part : t_else statement {  // pid=69
        std::cerr << "Use production: else_part -> else statement" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_ELSE_PART, "", children), 69, vid, vnum);
    }
    | t_else  {  // pid = 70
        std::cerr << "Use production: else_part -> else" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_ELSE_PART, "", children), 70, vid, vnum);
    };

expression_list : expression_list ',' expression {  // pid=71
        std::cerr << "Use production: expression_list -> expression_list , expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_EXPRESSION_LIST, "", children), 71, vid, vnum);
    }
    |expression {
        std::cerr << "Use production: expression_list -> expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_EXPRESSION_LIST, "", children), 72, vid, vnum);
    };

expression : simple_expression {  // pid=73
        std::cerr << "Use production: expression -> simple_expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_EXPRESSION, "", children), 73, vid, vnum);
    }
    | simple_expression relop simple_expression {  // pid=74
        std::cerr << "Use production: expression -> simple_expression relop simple_expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_EXPRESSION, "", children), 74, vid, vnum);
    }
    | simple_expression '=' simple_expression {  // pid=75
        std::cerr << "Use production: expression -> simple_expression = simple_expression" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_EXPRESSION, "", children), 75, vid, vnum);
    };

simple_expression : term {  // pid=76
        std::cerr << "Use production: simple_expression -> term" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SIMPLE_EXPRESSION, "", children), 76, vid, vnum);
    }
    | term '+' term {  // pid=77
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SIMPLE_EXPRESSION, "", children), 77, vid, vnum);
    }
    | term '-' term {  // pid=78
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SIMPLE_EXPRESSION, "", children), 78, vid, vnum);
    }
    | term or_op term {  // pid=79
        std::cerr << "Use production: simple_expression -> term addop term" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_SIMPLE_EXPRESSION, "", children), 79, vid, vnum);
    };

term : factor {  // pid=80
        std::cerr << "Use production: term -> factor" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_TERM, "", children), 80, vid, vnum);
    }
    | term mulop factor {  // pid=81
        std::cerr << "Use production: term -> term mulop factor" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_TERM, "", children), 81, vid, vnum);
    }

factor : '(' expression ')' {  // pid=82
        std::cerr << "Use production: factor -> ( expression )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 82, vid, vnum);
    }
    | variable {  // pid=83
        std::cerr << "Use production: factor -> variable" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($1->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 83, vid, vnum);
    }
    | id '(' expression_list ')' {  // pid=84
        std::cerr << "Use production: factor -> id ( expression_list )" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        children.push_back($3->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 84, vid, vnum);
    }
    | num {
        std::cerr << "Use production: factor -> num" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        vid.push_back($1);
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 85, vid, vnum);
    }
    | notop factor {  // pid=86
        std::cerr << "Use production: factor -> notop factor" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 86, vid, vnum);
    }
    | '-' factor {  // pid=87
        std::cerr << "Use production: factor -> - factor" << std::endl;
        vector<tree::TreeNode> children;
        vector<std::string> vid;
        vector<std::string> vnum;
        children.push_back($2->get_root());
        $$ = tree::Tree(std::make_shared<tree::TreeNode>(Tree::T_FACTOR, "", children), 87, vid, vnum);
    };


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