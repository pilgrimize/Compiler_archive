
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