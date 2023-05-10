#include "generate.h"
#include "semantic.h"
#include <iostream>
#include <cassert>

namespace generate {
using symbol::symbol_table_tree;

bool generate_by_pid(tree::TreeNode* node);

enum ID_LIST_TYPE{
    FUNCTION_DEFINITION,
    FUNCTION_CALL,
    FUNCTION_DECLARATION,
    PROGRAM_BODY
};
enum ID_TYPE{
    BRACKET,
    NON_BRACKET
};
std::string query_basic_type(const std::string name){
    if(symbol_table_tree.get_current_node()->get_entry(name)->type == symbol::TYPE_BASIC){
        switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(name)->extra_info).basic){
            case symbol::TYPE_INT:
                return "int";
            case symbol::TYPE_SINGLE:
            case symbol::TYPE_FLOAT:
                return "float ";
            case symbol::TYPE_CHAR:
                return "char ";
            case symbol::TYPE_BOOL:
                return "bool ";
            case symbol::TYPE_STRING:
                return "std::string ";
            case symbol::TYPE_DOUBLE:
                return "double ";
            case symbol::TYPE_SHORTINT:
                return "short int ";
            case symbol::TYPE_LONGINT:
                return "long ";
            case symbol::TYPE_BYTE:
                return "char ";
            default:
                return "ERROR query_basic_type";
        }
    }
    if(symbol_table_tree.get_current_node()->get_entry(name)->type == symbol::TYPE_ARRAY){
        switch (std::get<symbol::ArrayInfo>(symbol_table_tree.get_current_node()->get_entry(name)->extra_info).basic){
            case symbol::TYPE_INT:
                return "int";
            case symbol::TYPE_SINGLE:
            case symbol::TYPE_FLOAT:
                return "float ";
            case symbol::TYPE_CHAR:
                return "char ";
            case symbol::TYPE_BOOL:
                return "bool ";
            case symbol::TYPE_STRING:
                return "char* ";
            case symbol::TYPE_DOUBLE:
                return "double ";
            case symbol::TYPE_SHORTINT:
                return "short int ";
            case symbol::TYPE_LONGINT:
                return "long ";
            case symbol::TYPE_BYTE:
                return "char ";
            default:
                return "ERROR query_basic_type";
        }
    }
    if(symbol_table_tree.get_current_node()->get_entry(name)->type == symbol::TYPE_FUNCTION){
        switch (std::get<symbol::FunctionInfo>(symbol_table_tree.get_current_node()->get_entry(name)->extra_info).ret_type){
            case symbol::TYPE_INT:
                return "int";
            case symbol::TYPE_FLOAT:
                return "float";
            case symbol::TYPE_CHAR:
                return "char";
            case symbol::TYPE_BOOL:
                return "bool";
        }
    }
}

void varpart_process(tree::TreeNode* node){
    std::string array_name = node->get_child(0)->get_text();
    std::vector<int> bias;
    std::vector<tree::TreeNode*> expr;
    for(auto per_dim: std::get<symbol::ArrayInfo>(symbol_table_tree.get_entry(array_name)->extra_info).dims){
        bias.push_back(per_dim.first);
    }
    node = node->get_child(1)->get_child(1);    //expression_list
    while(node->get_pid() != tree::expression_list__T__expression){
        expr.push_back(node->get_child(2));
        node = node->get_child(0);
    }
    expr.push_back(node->get_child(0));
    std::reverse(expr.begin(), expr.end());
    assert(bias.size() == expr.size());
    for(int i = 0; i < bias.size(); ++i){
        logger::output( "[");
        generate_by_pid(expr[i]);
        logger::output( "-(" +std::to_string(bias[i]) + ")]");
    }
}

void id_process(tree::TreeNode* node,ID_TYPE type){
    assert(symbol_table_tree.search_entry(node->get_text()) != symbol::SymbolTableTree::SearchResult::NOT_FOUND);
    switch(symbol_table_tree.get_entry(node->get_text())->type){
        case symbol::TYPE_BASIC:
            if(type == NON_BRACKET){
                if(symbol_table_tree.get_scope_name() == node->get_text()){
                    logger::output( "_");
                }
                if(std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(node->get_text())->extra_info).is_referred){
                    logger::output( "*");
                }
                logger::output( node->get_text());
            }
            else{
               
                if(std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(node->get_text())->extra_info).is_referred)
                    logger::output( "*");
                logger::output( node->get_text());
            }
            break;
        case symbol::TYPE_ARRAY:
            logger::output( node->get_text());
            for(auto per_dim: std::get<symbol::ArrayInfo>(symbol_table_tree.get_entry(node->get_text())->extra_info).dims){
                logger::output( (std::string)"[" +std::to_string(per_dim.second - per_dim.first + 1)+ "]");
            }
            break;
        case symbol::TYPE_RECORD:
            break;
        case symbol::TYPE_FUNCTION:
            if(type == NON_BRACKET){
                if(symbol_table_tree.get_scope_name() != node->get_text()){
                    logger::output( node->get_text() + (std::string)"()");
                }
                else {
                    logger::output( "_" + node->get_text());
                }
            }
            else{logger::output( node->get_text());}
            break;
        default:
            logger::log("ERROR!");
    }
}

void idlist_process(tree::TreeNode* node, ID_LIST_TYPE type){
    std::vector<tree::TreeNode*> varible_list;
    tree::TreeNode* now = node;
    while (now->get_pid() != tree::idlist__T__id){
        varible_list.push_back(now->get_child(2));
        now = now->get_child(0);
    }
    varible_list.push_back(now->get_child(0));
    std::reverse(varible_list.begin(), varible_list.end());
    switch (type){
        case FUNCTION_DECLARATION:
        case FUNCTION_DEFINITION:
            for (auto it = varible_list.begin(); it != varible_list.end(); ){
                auto varible = *it;
                logger::output( query_basic_type(varible->get_text()) + " ");
                id_process(varible,NON_BRACKET);
                ++it;
                if(it!=varible_list.end())logger::output( ", ");
            }
            break;
        case PROGRAM_BODY:
            for (auto it = varible_list.begin(); it != varible_list.end(); ){
                auto varible = *it;
                id_process(varible,NON_BRACKET);
                if(symbol_table_tree.get_entry(varible->get_text())->type == symbol::TYPE_BASIC){// == symbol::TYPE_STRING){
                    if(std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(varible->get_text())->extra_info).basic == symbol::TYPE_STRING)
                        logger::output( " = (char *)malloc(sizeof(char) * STRING_SIZE)");
                }
                //std::cerr << varible->get_type() << varible->get_pid() << varible->get_text();
                ++it;
                if(it!=varible_list.end())logger::output( ", ");
            }    
            break;
        default:
            logger::log("ERROR: no type info!");
    }
}

void function_call_para(tree::TreeNode* node, tree::TreeNode* func_node){
    std::vector<tree::TreeNode*> expr;
    while(node->get_pid() == tree::expression_list__T__expression_list__comma__expression){
        expr.push_back(node->get_child(2));
        node = node->get_child(0);
    }
    expr.push_back(node->get_child(0));
    std::reverse(expr.begin(), expr.end());
    std::vector<symbol::Param> *paralist;
    if(symbol_table_tree.get_scope_name() != func_node->get_text())
        paralist = &(std::get<symbol::FunctionInfo>(symbol_table_tree.get_current_node()->get_entry(func_node->get_text())->extra_info).params);
    else
        paralist = &(std::get<symbol::FunctionInfo>(symbol_table_tree.get_current_node()->get_parent()->get_entry(func_node->get_text())->extra_info).params);
    assert(paralist->size() == expr.size());
    for(int i=0;i<expr.size();++i){
        if((*paralist)[i].is_referred&&(*paralist)[i].type!=symbol::TYPE_STRING){
            logger::output( "&");
        }
        generate_by_pid(expr[i]);
        if(i!=expr.size()-1)logger::output(", ");
    }

}

int indent = 0;
void input_tab(bool enter, int indentoffset = 0){
    if(enter)logger::output( "",true);
    for(int i=0;i<indent+indentoffset ;++i)logger::output( "\t");
}

bool generate_by_pid(tree::TreeNode* node) {
    if (node == nullptr) return true;
    switch (node->get_token()) {  
        case tree::T_PROGRAM_STRUCT: {
            for(int i=0;i+1<(node->get_child(2)->get_children()).size();++i){
                generate_by_pid(node->get_child(2)->get_child(i));
            }
            logger::output( "int main(){");
            indent++;
            input_tab(true);
            generate_by_pid(*(node->get_child(2)->get_children().rbegin()));
            input_tab(true);
            logger::output( "return 0;");
            indent--;
            input_tab(true);
            logger::output((std::string) "}",true);
            break;
        }
        case tree::T_CONST_DECLARATIONS:{ 
            generate_by_pid(node->get_child(1));
            logger::output((std::string)";");
            input_tab(true);
            break;
        }
        case tree::T_CONST_DECLARATION:{  
            switch (node->get_pid()){
                case tree::const_declaration__T__id__equalop__const_value:
                    logger::output( "const ");
                    switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_child(0)->get_text())->extra_info).basic){
                        case symbol::TYPE_INT:
                            logger::output( "int ");
                            break;
                        case symbol::TYPE_FLOAT:
                            logger::output( "float ");
                            break;
                        case symbol::TYPE_CHAR:
                            logger::output( "char ");
                            break;
                        case symbol::TYPE_BOOL:
                            logger::output( "bool ");
                            break;
                    }
                    id_process(node->get_child(0),NON_BRACKET);
                    logger::output( "=");
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::const_declaration__T__const_declaration__semicolon__id__equalop__const_value:
                    generate_by_pid(node->get_child(0));
                    logger::output((std::string)";");
                    input_tab(true);
                    logger::output( "const ");
                    switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_child(2)->get_text())->extra_info).basic){
                        case symbol::TYPE_INT:
                            logger::output( "int ");
                            break;
                        case symbol::TYPE_FLOAT:
                            logger::output( "float ");
                            break;
                        case symbol::TYPE_CHAR:
                            logger::output( "char ");
                            break;
                        case symbol::TYPE_BOOL:
                            logger::output( "bool ");
                            break;
                    }
                    id_process(node->get_child(2),NON_BRACKET);
                    logger::output( "=");
                    generate_by_pid(node->get_child(4));
                    break;
            }
            break;
        }
        case tree::T_CONST_VALUE:{    
            switch (node->get_pid()){
                case tree::const_value__T__num:
                case tree::const_value__T__literal_char:
                case tree::const_value__T__double_value:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::const_value__T__addop__num:
                    logger::output( "+");
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::const_value__T__subop__num:
                    logger::output( "-");
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::const_value__T__addop__double_value:
                    logger::output( "+");
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::const_value__T__subop__double_value:
                    logger::output( "-");
                    logger::output( "(");
                    generate_by_pid(node->get_child(0));
                    logger::output( ")");
                    break;
                default:
                    logger::log("error: const_value"+std::to_string( node->get_pid() ));
            }
            break;
        }
        case tree::T_VAR_DECLARATIONS:{   
            generate_by_pid(node->get_child(1));
            logger::output((std::string)";");
            input_tab(true);
            break;
        }
        case tree::T_VAR_DECLARATION:{  
            switch (node->get_pid()){
                case tree::var_declaration__T__idlist__colon__type:
                    generate_by_pid(node->get_child(2));
                    logger::output( " ");
                    idlist_process(node->get_child(0), PROGRAM_BODY);
                    break;
                case tree::var_declaration__T__var_declaration__semicolon__idlist__colon__type:
                    generate_by_pid(node->get_child(0));
                    logger::output((std::string)";");
                    input_tab(true);
                    generate_by_pid(node->get_child(4));
                    logger::output( " ");
                    idlist_process(node->get_child(2), PROGRAM_BODY);
                    break;
            }
            break;
        }
        case tree::T_TYPE:{
            switch (node->get_pid()){
                case tree::type__T__basic_type:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::type__T__t_array__leftbracket__period__rightbracket__t_of__basic_type:
                    generate_by_pid(node->get_child(5));
                    break;
            }
            break;
        }
        case tree::T_BASIC_TYPE:{
            generate_by_pid(node->get_child(0));
            break;
        }
        
        case tree::T_SUBPROGRAM_DECLARATIONS:{  
            switch (node->get_pid()){
                case tree::subprogram_declarations__T__subprogram__semicolon:
                    generate_by_pid(node->get_child(0));
                    input_tab(true);
                    break;
                case tree::subprogram_declarations__T__subprogram_declarations__subprogram__semicolon:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    input_tab(true);
                    break;
                default:
                    logger::log("error: subprogram_declarations"+std::to_string( node->get_pid() ));
                    break;
            }
            break;
        }
        case tree::T_SUBPROGRAM:{
            symbol_table_tree.next_scope();
            if(node->get_child(0)->get_pid() == tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
                                                    ||node->get_child(0)->get_pid() == tree::subprogram_head__T__t_function__id__colon__basic_type){
                std::string func_name = node->get_child(0)->get_child(1)->get_text();
                generate_by_pid(node->get_child(0));
                logger::output( "{");
                indent++;
                input_tab(true);
                logger::output( query_basic_type(func_name) + " _" + func_name + ";");
                input_tab(true);
                generate_by_pid(node->get_child(2));
                input_tab(true);
                logger::output( "return _" + func_name + ";");
                indent--;
                input_tab(true);
                logger::output( (std::string)"}");
                // indent--;
                // input_tab(true);
            }
            else{
                generate_by_pid(node->get_child(0));
                logger::output( "{");
                indent++;
                input_tab(true);
                generate_by_pid(node->get_child(2));
                indent--;
                input_tab(true);
                logger::output((std::string)"}");
                
            }
            symbol_table_tree.pop_scope();
            break;
        }
        case tree::T_SUBPROGRAM_HEAD:{   
            switch (node->get_pid()){
                case tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type:
                    logger::output( query_basic_type(node->get_child(1)->get_text()) + " ");
                    id_process(node->get_child(1),BRACKET);
                    generate_by_pid(node->get_child(2));

                    break;
                case tree::subprogram_head__T__t_procedure__id__formal_parameter:
                    logger::output( "void ");
                    logger::output( node->get_child(1)->get_text());
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::subprogram_head__T__t_function__id__colon__basic_type:
                    logger::output( query_basic_type(node->get_child(1)->get_text()) + (std::string)" ");
                    id_process(node->get_child(1),BRACKET);
                    logger::output( "()");
                    break;
                case tree::subprogram_head__T__t_procedure__id:
                    logger::output( "void ");
                    logger::output( node->get_child(1)->get_text());
                    logger::output( "()");
                    break;
            }
            break;
        }
        case tree::T_FORMAL_PARAMETER:{  
            switch (node->get_pid()){
                case tree::formal_parameter__T__leftparen__parameter_list__rightparen:
                    logger::output( "(");
                    generate_by_pid(node->get_child(1));
                    logger::output( ")");
                    break;
                case tree::formal_parameter__T__leftparen__rightparen:
                    logger::output( "()");
                default:
                    break;
            }
        }
        case tree::T_PARAMETER_LIST:{  
            switch (node->get_pid()){
                case tree::parameter_list__T__parameter:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::parameter_list__T__parameter_list__semicolon__parameter:
                    generate_by_pid(node->get_child(0));
                    logger::output( ",");
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_PARAMETER:{  
            generate_by_pid(node->get_child(0));
            break;
        }
        case tree::T_VAR_PARAMETER:{    
            generate_by_pid(node->get_child(1));
            break;
        }
        case tree::T_VALUE_PARAMETER:{  
            idlist_process(node->get_child(0), ID_LIST_TYPE::FUNCTION_DEFINITION);
            break;
        }
        case tree::T_SUBPROGRAM_BODY:{  
            for(auto child_node:node->get_children()){
                generate_by_pid(child_node);
            }
        }
        case tree::T_COMPOUND_STATEMENT:{  
            switch (node->get_pid()){
                case tree::compound_statement__T__t_begin__statement_list__t_end:
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::compound_statement__T__t_begin__t_end:
                    break;
            }
            break;
        }
        case tree::T_STATEMENT_LIST:{  
            switch (node->get_pid()){
                case tree::statement_list__T__statement:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::statement_list__T__statement_list__semicolon__statement:
                    generate_by_pid(node->get_child(0));
                    input_tab(true);
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_STATEMENT:{     
            std::vector<tree::TreeNode*> varible_list;
            tree::TreeNode* now;
            switch (node->get_pid()){
                case tree::statement__T__variable__assignop__expression:        //fall through!
                    generate_by_pid(node->get_child(0));
                    logger::output( "=");                    
                    generate_by_pid(node->get_child(2));
                    logger::output((std::string) ";");
                    //input_tab(true);
                    break;
                case tree::statement__T__procedure_call:  
                    generate_by_pid(node->get_child(0));
                    break;      
                case tree::statement__T__compound_statement:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::statement__T__t_if__expression__t_then__statement:
                    logger::output( "if(");
                    generate_by_pid(node->get_child(1));
                    logger::output( "){");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(3)); 
                    indent--;
                    input_tab(true);                 
                    logger::output((std::string)"}");                   
                    break;
                case tree::statement__T__t_if__expression__t_then__statement__else_part:
                    logger::output( "if (");
                    generate_by_pid(node->get_child(1));
                    logger::output( "){");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(3));
                    indent--;
                    input_tab(true);
                    logger::output((std::string)"}");
                    input_tab(true);
                    generate_by_pid(node->get_child(4));
                    break;
                case tree::statement__T__t_while__T__expression__t_do__statement:
                    logger::output( "while(");
                    generate_by_pid(node->get_child(1));
                    logger::output( "){");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(3));
                    logger::output( (std::string)"}");
                    indent--;
                    //input_tab(true);
                    break;
                case tree::statement__T__t_repeat__statement__t_until__expression:
                case tree::statement__T__t_repeat__statement_list__t_until__expression:
                    logger::output( "do{");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(1));
                    indent--;
                    input_tab(true);
                    logger::output((std::string) "}"+"while"+"("+"!");
                    generate_by_pid(node->get_child(3));
                    logger::output( ");");
                    //input_tab(true);
                    break;
                case tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement:    
                    logger::output( "for(");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output( "=");
                    generate_by_pid(node->get_child(3));
                    logger::output( "; ");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output( "<=");
                    generate_by_pid(node->get_child(5));
                    logger::output( "; ");
                    logger::output( "++");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output( "){");
                    indent++;
                    input_tab(true);
                    assert(node->get_children().size() > 7);
                    generate_by_pid(node->get_child(7));
                    indent--;
                    input_tab(true);
                    logger::output((std::string)"}");

                    break;
                case tree::statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__statement:
                    logger::output((std::string) "for"+"(");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output( "=");
                    generate_by_pid(node->get_child(3));
                    logger::output( "; ");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output((std::string) ">"+"=");
                    generate_by_pid(node->get_child(5));
                    logger::output( "; ");
                    logger::output( "--");
                    id_process(node->get_child(1), NON_BRACKET);
                    logger::output((std::string) ")"+"{");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(7));
                    logger::output((std::string)"}");
                    indent--;
                    //input_tab(true);
                    break;
                case tree::statement__T__t_read__leftparen__variable_list__rightparen:    //fall through!
                case tree::statement__T__t_readln__leftparen__variable_list__rightparen:
                    varible_list.clear();
                    now = node->get_child(2);
                    while (now->get_pid() != tree::variable_list__T__variable){
                        varible_list.push_back(now->get_child(2));
                        now = now->get_child(0);
                    }
                    varible_list.push_back(now->get_child(0));
                    std::reverse(varible_list.begin(), varible_list.end());
                    logger::output( "scanf(\"");
                    for (auto now_var : varible_list){
                        if(symbol_table_tree.get_current_node()->get_entry(now_var->get_child(0)->get_text())->type == symbol::TYPE_BASIC){
                            switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(now_var->get_child(0)->get_text())->extra_info).basic){
                            case symbol::TYPE_SHORTINT:
                                logger::output( "%hd");
                                break;
                            case symbol::TYPE_INT:
                                logger::output( "%d");
                                break;
                            case symbol::TYPE_LONGINT:
                                logger::output( "%ld");
                                break;
                            case symbol::TYPE_CHAR:
                                logger::output( "%c");
                                break;
                            case symbol::TYPE_SINGLE:
                            case symbol::TYPE_FLOAT:
                                logger::output( "%f");
                                break;
                            case symbol::TYPE_DOUBLE:
                                logger::output( "%lf");
                                break;
                            case symbol::TYPE_STRING:
                                logger::output( "%s");
                                break;
                            default:
                                logger::output( "%d");
                                break;
                            }
                        }
                        else if(symbol_table_tree.get_current_node()->get_entry(now_var->get_child(0)->get_text())->type == symbol::TYPE_ARRAY){
                            switch (std::get<symbol::ArrayInfo>(symbol_table_tree.get_entry(now_var->get_child(0)->get_text())->extra_info).basic){
                            case symbol::TYPE_SHORTINT:
                                logger::output( "%hd");
                                break;
                            case symbol::TYPE_INT:
                                logger::output( "%d");
                                break;
                            case symbol::TYPE_LONGINT:
                                logger::output( "%ld");
                                break;
                            case symbol::TYPE_CHAR:
                                logger::output( "%c");
                                break;
                            case symbol::TYPE_SINGLE:
                            case symbol::TYPE_FLOAT:
                                logger::output( "%f");
                                break;
                            case symbol::TYPE_DOUBLE:
                                logger::output( "%lf");
                                break;
                            case symbol::TYPE_STRING:
                                logger::output( "%s");
                                break;
                            default:
                                logger::output( "%d");
                                break;
                            }                            
                        }
                    }
                    logger::output( "\"");
                    for (auto now_var : varible_list){
                        logger::output( ", ");
                        if(now_var->get_type() != symbol::TYPE_STRING)
                            logger::output( "&");
                        generate_by_pid(now_var);
                    }
                    logger::output( ");");
                    //input_tab(true);
                    break;
                case tree::statement__T__t_write__leftparen__expression_list__rightparen:
                case tree::statement__T__t_writeln__leftparen__expression_list__rightparen:
                    varible_list.clear();
                    now = node->get_child(2);
                    while (now->get_pid() != tree::expression_list__T__expression){
                        varible_list.push_back(now->get_child(2));
                        now = now->get_child(0);

                    }
                    varible_list.push_back(now->get_child(0));
                    std::reverse(varible_list.begin(), varible_list.end());
                    logger::output( "printf(\"");
                    for (auto now_var : varible_list){
                        switch (now_var->get_type()){
                            case symbol::TYPE_SHORTINT:
                                logger::output( "%hd");
                                break;
                            case symbol::TYPE_INT:
                                logger::output( "%d");
                                break;
                            case symbol::TYPE_LONGINT:
                                logger::output( "%ld");
                                break;
                            case symbol::TYPE_CHAR:
                                logger::output( "%c");
                                break;
                            case symbol::TYPE_SINGLE:
                            case symbol::TYPE_FLOAT:
                                logger::output( "%f");
                                break;
                            case symbol::TYPE_DOUBLE:
                                logger::output( "%lf");
                                break;
                            case symbol::TYPE_STRING:
                                logger::output( "%s");
                                break;
                            default:
                                logger::output( "%d");
                                break;
                        }
                    }
                    if(node->get_pid() == tree::statement__T__t_writeln__leftparen__expression_list__rightparen)
                        logger::output( "\\n");
                    logger::output( "\"");
                    for (auto now_var : varible_list){
                        logger::output( ", ");
                        generate_by_pid(now_var);
                    }
                    logger::output( ");");
                    //input_tab(true);
                    break;
                default:
                    logger::log("T_STATEMENT ERROR " + std::to_string(node->get_pid()));
                    break;
            }
            break;
        }
        case tree::T_VARIABLE_LIST:{  
            switch (node->get_pid()){   
                case tree::variable_list__T__variable:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::variable_list__T__variable_list__comma__variable:
                    generate_by_pid(node->get_child(1));
                    logger::output( ", ");
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_VARIABLE:{    
            switch (node->get_pid()){
                case tree::variable__T__id:
                    id_process(node->get_child(0), NON_BRACKET);
                    break;
                case tree::variable__T__id__id_varpart:
                    logger::output( node->get_child(0)->get_text());
                    varpart_process(node);
                    break;
            }
            break;
        }
        case tree::T_PROCEDURE_CALL: 
            switch (node->get_pid()){
                case tree::procedure_call__T__id__leftparen__expression_list__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    logger::output( "(");
                    function_call_para(node->get_child(2), node->get_child(0));
                    logger::output( ")");
                    logger::output(";");
                    //input_tab(true);
                    break;
                case tree::procedure_call__T__id:
                    id_process(node->get_child(0), NON_BRACKET);
                    break;
                case tree::procedure_call__T__id__leftparen__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    logger::output("();");
                    break;
            }
            break;
        case tree::T_ELSE_PART:    
            switch (node->get_pid()){
                case tree::else_part__T__t_else__statement:
                    logger::output( "else{");
                    indent++;
                    input_tab(true);
                    generate_by_pid(node->get_child(1));
                    indent--;
                    input_tab(true);
                    logger::output((std::string)"}");
                    break;
                case tree::else_part__T__t_else:
                    //do nothing
                    break;
            }
            break;
        case tree::T_EXPRESSION_LIST:{     
            switch (node->get_pid()){
                case tree::expression_list__T__expression_list__comma__expression:
                    generate_by_pid(node->get_child(0));
                    logger::output( ", ");
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::expression_list__T__expression:
                    generate_by_pid(node->get_child(0));
                    break;
            }
            break;
        }
        case tree::T_EQUALOP:
            logger::output( "=");
            break;
        case tree::T_RELOP:
            if(node->get_text() == "<>")
                logger::output("!=");
            else 
                logger::output(node->get_text());
            break;
        case tree::T_SUBOP:
            logger::output( "-");
            break;
        case tree::T_ADDOP:
            logger::output( "+");
            break;
        case tree::T_MULOP:
            if(node->get_text() == "mod")logger::output( "%");
            else if(node->get_text() == "*")logger::output( "*");
            else if(node->get_text() == "div")logger::output( "/");
            else if(node->get_text() == "and")logger::output( "&");
            else if(node->get_text() == "/")logger::output( "/");
            else {
                logger::log("ERROR: MULOP: " + node->get_text());
            }
            break;
        case tree::T_OR_OP:
            logger::output( "|");
            break;
        case tree::T_EXPRESSION:{
            switch (node->get_pid()){ 
                case tree::expression__T__simple_expression:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::expression__T__simple_expression__relop__simple_expression:    //fall through!
                case tree::expression__T__simple_expression__equalop__simple_expression:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_SIMPLE_EXPRESSION:{ 
            switch (node->get_pid()){
                case tree::simple_expression__T__term:  //fall!
                case tree::simple_expression__T__literal_char:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::simple_expression__T__term__addop__term:    //fall through!
                case tree::simple_expression__T__term__subop__term:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));                    
                    break;
                case tree::simple_expression__T__term__or_op__term:
                    logger::output("(");
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));
                    logger::output(")");             
                    break;
                case tree::simple_expression__T__literal_string:
                    logger::output( "\"" + node->get_child(0)->get_text().substr(1, node->get_child(0)->get_text().size()-2) + "\"");
                    break;
                default:
                    logger::log("ERROR SIMPLE EXPRESSION:"+ node->get_pid());
            }
            break;
        }
        case tree::T_TERM:{    
            switch (node->get_pid()){
                case tree::term__T__factor:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::term__T__term__mulop__factor:
                    if(node->get_child(1)->get_text() == "and")logger::output("(");
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));
                    if(node->get_child(1)->get_text() == "and")logger::output(")");
                    break; 
                default:
                    logger::log("ERROR T_TERM:"+ node->get_pid()); 
            }
            break;
        }
        case tree::T_FACTOR:{   
            switch (node->get_pid()){
                case tree::factor__T__leftparen__expression__rightparen:
                    logger::output( "(");
                    generate_by_pid(node->get_child(1));
                    logger::output( ")");
                    break;
                case tree::factor__T__variable:    //fall through!
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::factor__T__num: 
                    logger::output( node->get_child(0)->get_text());
                    break;
                case tree::factor__T__id__leftparen__expression_list__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    logger::output( "(");
                    function_call_para(node->get_child(2), node->get_child(0));
                    logger::output( ")");
                    break;
                case tree::factor__T__id__leftparen__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    logger::output( "()");           
                    break;     
                case tree::factor__T__notop__factor:
                    logger::output( "!");
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::factor__T__subop__factor:
                    logger::output( "-(");
                    generate_by_pid(node->get_child(1));
                    logger::output( ")");
                    break;
                case tree::factor__T__bool_value:
                    logger::output( node->get_child(0)->get_text());
                    break;
                case tree::factor__T__double_value:
                    logger::output( node->get_child(0)->get_text());
                    break;
                default:
                    logger::log("ERROR T_FACTOR:"+node->get_pid());
            }
            break;
        }
        case tree::T_DOUBLE_VALUE:
            logger::output(node->get_text());
            break;
        case tree::T_INTEGER:
            logger::output( "int");
            break;       
        case tree::T_CHAR:
            logger::output( "char");
            break;         
        case tree::T_BOOLEAN:
            logger::output( "bool");
            break; 
        case tree::T_DOUBLE:
            logger::output( "double");
            break;               
        case tree::T_QUATEOP:
            logger::output( "==");
            break;
        case tree::T_LITERAL_INT:
            logger::output( "int");
            break;
        case tree::T_LITERAL_BOOL:
            logger::output( "bool");
            break;
        case tree::T_STRING:
            logger::output( "char*");
            break;
        case tree::T_LONGINT:
            logger::output( "long int");
            break;
        case tree::T_LITERAL_CHAR:
            logger::output( node->get_text());
            break;
        case tree::T_SINGLE:
            logger::output( "float");
            break;
        case tree::T_BYTE:
            logger::output( "char");
            break;
        default:
            logger::log("ERROR TOKEN:"+std::to_string(node->get_token() ));
            break;
    }
    return true;
}
bool generate_code(){
    logger::output("#include <stdio.h>",true);
    logger::output("#include <stdlib.h>" ,true);
    logger::output("#include <stdbool.h>" ,true);
    logger::output("#define STRING_SIZE 1000",true);
    return generate_by_pid(tree::ast->get_root());
    return true;
}

}