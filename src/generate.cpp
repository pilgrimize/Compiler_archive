#include "generate.h"
#include "semantic.h"
#include <iostream>
#include <cassert>

namespace generate {
using symbol::symbol_table_tree;

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
            case symbol::TYPE_FLOAT:
                return "float ";
            case symbol::TYPE_CHAR:
                return "char ";
            case symbol::TYPE_BOOL:
                return "bool ";
        }
    }
    if(symbol_table_tree.get_current_node()->get_entry(name)->type == symbol::TYPE_ARRAY){
        switch (std::get<symbol::ArrayInfo>(symbol_table_tree.get_current_node()->get_entry(name)->extra_info).basic){
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
    // if(symbol_table_tree.get_current_node()->get_entry(name)->type == symbol::TYPE_RECORD){

    // }
}

void id_process(tree::TreeNode* node,ID_TYPE type){//to do: change the dims and reference
    switch(symbol_table_tree.get_current_node()->get_entry(node->get_text())->type){
        case symbol::TYPE_BASIC:
            if(type == NON_BRACKET){
                if(symbol_table_tree.get_scope_name() == node->get_text()){
                    std::cout << "_";
                }
                std::cout << node->get_text();
            }
            else{
                if(std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_text())->extra_info).is_referred)
                    std::cout << "*";
                std::cout << node->get_text();
            }
            break;
        case symbol::TYPE_ARRAY:
            std::cout << node->get_text();
            for(auto per_dim: std::get<symbol::ArrayInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_text())->extra_info).dims){
                std::cout << "[" << per_dim.second + 1 << "]";
            }
            break;
        case symbol::TYPE_RECORD:
            break;
        case symbol::TYPE_FUNCTION:
            if(type == NON_BRACKET){
                if(symbol_table_tree.get_scope_name() != node->get_text()){
                    std::cout << node->get_text() << "()";
                }
                else {
                    std::cout << "_" << node->get_text();
                }
            }
            else{std::cout << node->get_text(); }
            break;
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
                std::cout << query_basic_type(varible->get_text()) << " ";
                id_process(varible,NON_BRACKET);
                ++it;
                if(it!=varible_list.end())std::cout << ", ";
            }
            break;
        // case FUNCTION_CALL:
        //     for (auto it = varible_list.begin(); it != varible_list.end(); ){
        //         auto varible = *it;
        //         if(symbol_table_tree.get_current_node()->get_entry(varible->get_text())->type == symbol::ComplexType::TYPE_BASIC){
        //             if(std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(varible->get_text())->extra_info).is_referred)
        //                 std::cout << "&";
        //         }
        //         id_process(varible,NON_BRACKET);
        //         ++it;
        //         if(it!=varible_list.end())std::cout << ", ";
        //     }    
        //     break;
        case PROGRAM_BODY:
            for (auto it = varible_list.begin(); it != varible_list.end(); ){
                auto varible = *it;
                id_process(varible,NON_BRACKET);
                ++it;
                if(it!=varible_list.end())std::cout << ", ";
            }    
            break;
        default:
            std::cout << "ERROR: no type info!" << std::endl;
    }
}

int indent = 0;
void enter_and_tab(){
    std::cout << std::endl;
    for(int i=0;i<indent;++i)std::cout << "\t";
}
// TODO: 1.id 2.symbol_table_tree.get_current_node() 3 tab and new line
// Generate C code, should always return true given a valid tree and symbol table
bool generate_by_pid(tree::TreeNode* node) {
    if (node == nullptr) return true;
    //std::cout << "/*  " << node->get_token() << "  */";
    switch (node->get_token()) {    //pid 1
        case tree::T_PROGRAM_STRUCT: {
            for(int i=0;i+1<(node->get_child(2)->get_children()).size();++i){
                generate_by_pid(node->get_child(2)->get_child(i));
            }
            std::cout << "int main(){";
            indent++;
            enter_and_tab();
            //to do:freopen
            // if(node->get_child(0)->get_pid() == 2){
            //     auto main_para = node->get_child(0)->get_child(3);
            // }
            generate_by_pid(*(node->get_child(2)->get_children().rbegin()));
            std::cout << "return 0;";
            indent--;
            enter_and_tab();
            std::cout << "}"<<std::endl;
            break;
        }
        case tree::T_CONST_DECLARATIONS:{   //pid 14
            generate_by_pid(node->get_child(1));
            std::cout << ";";
            enter_and_tab();
            break;
        }
        case tree::T_CONST_DECLARATION:{    //pid 15~16
            switch (node->get_pid()){
                case tree::const_declaration__T__id__equalop__const_value:
                    std::cout << "const ";
                    switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_child(0)->get_text())->extra_info).basic){
                        case symbol::TYPE_INT:
                            std::cout << "int ";
                            break;
                        case symbol::TYPE_FLOAT:
                            std::cout << "float ";
                            break;
                        case symbol::TYPE_CHAR:
                            std::cout << "char ";
                            break;
                        case symbol::TYPE_BOOL:
                            std::cout << "bool ";
                            break;
                    }
                    id_process(node->get_child(0),NON_BRACKET);
                    std::cout << "=";
                    generate_by_pid(node->get_child(2));
                    enter_and_tab();
                    break;
                case tree::const_declaration__T__const_declaration__semicolon__id__equalop__const_value:
                    generate_by_pid(node->get_child(0));
                    std::cout << "const ";
                    switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(node->get_child(2)->get_text())->extra_info).basic){
                        case symbol::TYPE_INT:
                            std::cout << "int ";
                            break;
                        case symbol::TYPE_FLOAT:
                            std::cout << "float ";
                            break;
                        case symbol::TYPE_CHAR:
                            std::cout << "char ";
                            break;
                        case symbol::TYPE_BOOL:
                            std::cout << "bool ";
                            break;
                    }
                    id_process(node->get_child(2),NON_BRACKET);
                    std::cout << "=";
                    generate_by_pid(node->get_child(4));
                    enter_and_tab();
                    break;
            }
            break;
        }
        case tree::T_CONST_VALUE:{      //pid 17~20
            switch (node->get_pid()){
                case tree::const_value__T__num:   
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::const_value__T__literal:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::const_value__T__addop__num:
                    std::cout << "+";
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::const_value__T__subop__num:
                    std::cout << "-";
                    generate_by_pid(node->get_child(0));
                    break;
            }
            break;
        }
        case tree::T_VAR_DECLARATIONS:{     //pid:21
            generate_by_pid(node->get_child(1));
            std::cout << ";";
            enter_and_tab();
            break;
        }
        case tree::T_VAR_DECLARATION:{  //pid: 22~23
            switch (node->get_pid()){
                case tree::var_declaration__T__idlist__colon__type:
                    generate_by_pid(node->get_child(2));
                    std::cout << " ";
                    idlist_process(node->get_child(0), PROGRAM_BODY);
                    break;
                case tree::var_declaration__T__var_declaration__semicolon__idlist__colon__type:
                    generate_by_pid(node->get_child(0));
                    std::cout << ";";
                    enter_and_tab();
                    generate_by_pid(node->get_child(4));
                    std::cout << " ";
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
        
        case tree::T_SUBPROGRAM_DECLARATIONS:{  //pid: 31~32
            switch (node->get_pid()){
                case tree::subprogram_declarations__T__subprogram__semicolon:
                    generate_by_pid(node->get_child(0));
                    //std::cout << ";";
                    enter_and_tab();
                    break;
                case tree::subprogram_declarations__T__subprogram_declarations__subprogram__semicolon:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    // std::cout << ";";
                    enter_and_tab();
                    break;
            }
            break;
        }
        case tree::T_SUBPROGRAM:{
            symbol_table_tree.next_scope();
            if(node->get_child(0)->get_pid() == tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type
                                                    ||node->get_child(0)->get_pid() == tree::subprogram_head__T__t_function__id__colon__basic_type){
                
                std::string func_name = node->get_child(0)->get_child(1)->get_text();
                //std::cout << func_name;
                generate_by_pid(node->get_child(0));
                std::cout << "{";
                indent++;
                enter_and_tab();
                //to do: add definition of returnvalue
                // 
                std::cout << query_basic_type(func_name) << " _" << func_name << ";";
                enter_and_tab();
                generate_by_pid(node->get_child(2));
                enter_and_tab();
                //to do: return value
                std::cout << "return _" << func_name << ";";
                enter_and_tab();
                std::cout << "\b\b\b\b\b\b\b\b}";
                indent--;
                enter_and_tab();
            }
            else{
                generate_by_pid(node->get_child(0));
                std::cout << "{";
                indent++;
                enter_and_tab();
                generate_by_pid(node->get_child(2));
                indent--;
                enter_and_tab();
                std::cout << "}";
                enter_and_tab();
            }
            symbol_table_tree.pop_scope();
            break;
        }
        case tree::T_SUBPROGRAM_HEAD:{      //pid: 34~37
            //symbol_table_tree.next_scope();
            switch (node->get_pid()){
                case tree::subprogram_head__T__t_function__id__formal_parameter__colon__basic_type:
                    std::cout << query_basic_type(node->get_child(1)->get_text()) << " ";
                    id_process(node->get_child(1),BRACKET);
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::subprogram_head__T__t_procedure__id__formal_parameter:
                    std::cout << "void ";
                    id_process(node->get_child(1),BRACKET);
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::subprogram_head__T__t_function__id__colon__basic_type:
                    std::cout << query_basic_type(node->get_child(1)->get_text()) << " ";
                    id_process(node->get_child(1),BRACKET);
                    std::cout << "()";
                    break;
                case tree::subprogram_head__T__t_procedure__id:
                    std::cout << "void ";
                    std::cout << node->get_child(1)->get_text();
                    std::cout << "()";
                    break;
            }
            break;
        }
        case tree::T_FORMAL_PARAMETER:{     //pid: 38
            std::cout << "(";
            generate_by_pid(node->get_child(1));
            std::cout << ")";
            break;
        }
        case tree::T_PARAMETER_LIST:{   //pid: 39~40
            switch (node->get_pid()){
                case tree::parameter_list__T__parameter:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::parameter_list__T__parameter_list__semicolon__parameter:
                    generate_by_pid(node->get_child(0));
                    std::cout << ",";
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_PARAMETER:{    //pid: 41~42
            generate_by_pid(node->get_child(0));
            break;
        }
        case tree::T_VAR_PARAMETER:{    //pid: 43
            generate_by_pid(node->get_child(1));
            break;
        }
        case tree::T_VALUE_PARAMETER:{   //pid: 44
            idlist_process(node->get_child(0), ID_LIST_TYPE::FUNCTION_DEFINITION);
            break;
        }
        case tree::T_SUBPROGRAM_BODY:{   //pid 45~47
            for(auto child_node:node->get_children()){
                generate_by_pid(child_node);
            }
        }
        case tree::T_COMPOUND_STATEMENT:{   //pid 48~49
            switch (node->get_pid()){
                case tree::compound_statement__T__t_begin__statement_list__t_end:
                    generate_by_pid(node->get_child(1));
                    break;
                case tree::compound_statement__T__t_begin__t_end:
                    break;
            }
            break;
        }
        case tree::T_STATEMENT_LIST:{   //pid 50~51
            switch (node->get_pid()){
                case tree::statement_list__T__statement:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::statement_list__T__statement_list__semicolon__statement:
                    generate_by_pid(node->get_child(0));

                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_STATEMENT:{        //pid 52~62
            std::vector<tree::TreeNode*> varible_list;
            tree::TreeNode* now;
            switch (node->get_pid()){
                case tree::statement__T__variable__assignop__expression:        //fall through!
                    generate_by_pid(node->get_child(0));
                    std::cout << "=";
                    generate_by_pid(node->get_child(2));
                    std::cout << ";";
                    enter_and_tab();
                    break;
                case tree::statement__T__procedure_call:  
                    generate_by_pid(node->get_child(0));
                    break;      
                case tree::statement__T__compound_statement:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::statement__T__t_if__expression__t_then__statement:
                    std::cout << "if (";
                    generate_by_pid(node->get_child(1));
                    std::cout << "){";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(3));
                    std::cout << "\b\b\b\b\b\b\b\b}";
                    indent--;
                    break;
                case tree::statement__T__t_if__expression__t_then__statement__else_part:
                    std::cout << "if (";
                    generate_by_pid(node->get_child(1));
                    std::cout << "){";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(3));
                    std::cout << "\b\b\b\b\b\b\b\b}";
                    indent--;
                    enter_and_tab();
                    generate_by_pid(node->get_child(4));
                    break;
                case tree::statement__T__t_while__T__expression__t_do__statement:
                    std::cout << "while(";
                    generate_by_pid(node->get_child(1));
                    std::cout << "){";
                    indent++;
                    enter_and_tab();
                    //std::cout << node->get_child(3)->get_pid();
                    generate_by_pid(node->get_child(3));
                    std::cout << "\b\b\b\b\b\b\b\b}";
                    indent--;
                    enter_and_tab();
                    break;
                case tree::statement__T__t_repeat__statement__t_until__expression:
                    std::cout << "do{";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(1));
                    std::cout << "}while(!(";
                    generate_by_pid(node->get_child(3));
                    std::cout << "));";
                    indent--;
                    enter_and_tab();
                    break;
                case tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement:    
                    std::cout << "for(";
                    id_process(node->get_child(1), NON_BRACKET);
                    std::cout << "=";
                    generate_by_pid(node->get_child(3));
                    std::cout << "; ";
                    generate_by_pid(node->get_child(1));
                    if(node->get_pid() == 59)std::cout << "<=";
                    else std::cout << ">=";
                    generate_by_pid(node->get_child(5));
                    std::cout << "; ";
                    if(node->get_pid() == 59)std::cout << "++";
                    else std::cout << "--";
                    generate_by_pid(node->get_child(1));
                    std::cout << "){";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(7));
                    std::cout << "}";
                    indent--;
                    enter_and_tab();
                    break;
                case tree::statement__T__t_for__id__assignop__expression__t_downto__expression__t_do__statement:
                    std::cout << "for(";
                    id_process(node->get_child(1), NON_BRACKET);
                    std::cout << "=";
                    generate_by_pid(node->get_child(3));
                    std::cout << "; ";
                    generate_by_pid(node->get_child(1));
                    if(node->get_pid() == tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement)std::cout << "<=";
                    else std::cout << ">=";
                    generate_by_pid(node->get_child(5));
                    std::cout << "; ";
                    if(node->get_pid() == tree::statement__T__t_for__id__assignop__expression__t_to__expression__t_do__statement)std::cout << "++";
                    else std::cout << "--";
                    generate_by_pid(node->get_child(1));
                    std::cout << "){";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(7));
                    std::cout << "}";
                    indent--;
                    enter_and_tab();
                    break;
                case tree::statement__T__t_read__leftparen__variable_list__rightparen:    //fall through!
                    varible_list.clear();
                    now = node->get_child(2);
                    while (now->get_pid() != tree::variable_list__T__variable){
                        varible_list.push_back(now->get_child(2));
                        now = now->get_child(0);
                    }
                    varible_list.push_back(now->get_child(0));
                    std::reverse(varible_list.begin(), varible_list.end());
                    std::cout << "scanf(\"";
                    for (auto now_var : varible_list){
                        switch (std::get<symbol::BasicInfo>(symbol_table_tree.get_current_node()->get_entry(now_var->get_child(0)->get_text())->extra_info).basic){
                            case symbol::TYPE_INT:
                                std::cout << "%d";
                                break;
                            case symbol::TYPE_CHAR:
                                std::cout << "%c";
                                break;
                            case symbol::TYPE_FLOAT:
                                std::cout << "%f";
                                break;
                            default:
                                std::cout << "%d";
                                break;
                        }
                    }
                    std::cout << "\"";
                    for (auto now_var : varible_list){
                        std::cout << ", &";
                        generate_by_pid(now_var);
                    }
                    std::cout << ");";
                    enter_and_tab();
                    break;
                case tree::statement__T__t_write__leftparen__expression_list__rightparen:
                case tree::statement__T__t_writeln__leftparen__expression_list__rightparen:
                    //std::vector<tree::TreeNode*> varible_list;
                    varible_list.clear();
                    now = node->get_child(2);
                    while (now->get_pid() != tree::expression_list__T__expression){
                        varible_list.push_back(now->get_child(2));
                        now = now->get_child(0);

                    }
                    varible_list.push_back(now->get_child(0));
                    std::reverse(varible_list.begin(), varible_list.end());
                    std::cout << "printf(\"";
                    for (auto now_var : varible_list){
                        switch (now_var->get_type()){
                            case symbol::TYPE_INT:
                                std::cout << " %d";
                                break;
                            case symbol::TYPE_CHAR:
                                std::cout << " %c";
                                break;
                            case symbol::TYPE_FLOAT:
                                std::cout << " %f";
                                break;
                            case symbol::TYPE_STRING:
                                std::cout << " %s";
                                break;
                            default:
                                std::cout << " %d";
                                break;
                        }
                    }
                    if(node->get_pid() == tree::statement__T__t_writeln__leftparen__expression_list__rightparen)std::cout << "\\n";
                    std::cout << "\"";
                    for (auto now_var : varible_list){
                        std::cout << ", ";
                        generate_by_pid(now_var);
                    }
                    std::cout << ");";
                    enter_and_tab();
                    break;
            }
            break;
        }
        case tree::T_VARIABLE_LIST:{    //pid 63~64
            switch (node->get_pid()){   
                case tree::variable_list__T__variable:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::variable_list__T__variable_list__comma__variable:
                    generate_by_pid(node->get_child(1));
                    std::cout << ", ";
                    generate_by_pid(node->get_child(2));
                    break;
            }
            break;
        }
        case tree::T_VARIABLE:{     //pid 65~66
            switch (node->get_pid()){
                case tree::variable__T__id:
                    id_process(node->get_child(0), NON_BRACKET);
                    break;
                case tree::variable__T__id__id_varpart:
                    id_process(node->get_child(0), BRACKET);
                    generate_by_pid(node->get_child(1));
            }
            break;
        }
        case tree::T_ID_VARPART:    //pid 67
            std::cout << "[";
            generate_by_pid(node->get_child(1));
            std::cout << "]";
            break;
        case tree::T_PROCEDURE_CALL:    //pid 68~69
            switch (node->get_pid()){
                case tree::procedure_call__T__id__leftparen__expression_list__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    std::cout << "(";
                    generate_by_pid(node->get_child(2));
                    std::cout << ")";
                    break;
                case tree::procedure_call__T__id:
                    id_process(node->get_child(0), NON_BRACKET);
                    std::cout << ";";
                    enter_and_tab();
                    break;
            }
            break;
        case tree::T_ELSE_PART:     //pid 70~71
            switch (node->get_pid()){
                case tree::else_part__T__t_else__statement:
                    std::cout << "else{";
                    indent++;
                    enter_and_tab();
                    generate_by_pid(node->get_child(1));
                    indent--;
                    std::cout << "\b\b\b\b\b\b\b\b}";
                    
                    // enter_and_tab();
                    break;
                case tree::else_part__T__t_else:
                    //do nothing
                    break;
            }
            break;
        case tree::T_EXPRESSION_LIST:{      //pid 72~73
            switch (node->get_pid()){
                case tree::expression_list__T__expression_list__comma__expression:
                    generate_by_pid(node->get_child(0));
                    std::cout << ", ";
                    generate_by_pid(node->get_child(2));
                    break;
                case tree::expression_list__T__expression:
                    generate_by_pid(node->get_child(0));
                    break;
            }
            break;
        }
        case tree::T_EQUALOP:
            std::cout << "=";
            break;
        case tree::T_RELOP:
            std::cout << node->get_text();
            break;
        case tree::T_SUBOP:
            std::cout << "-";
            break;
        case tree::T_ADDOP:
            std::cout << "+";
            break;
        case tree::T_MULOP:
            std::cout << "*";
            break;
        case tree::T_OR_OP:
            std::cout << "||";
            break;
        case tree::T_EXPRESSION:{
            switch (node->get_pid()){   //pid 74~76
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
        case tree::T_SIMPLE_EXPRESSION:{    //pid 77~80
            switch (node->get_pid()){
                case tree::simple_expression__T__term:  //fall!
                case tree::simple_expression__T__literal_char:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::simple_expression__T__term__addop__term:    //fall through!
                case tree::simple_expression__T__term__subop__term:
                case tree::simple_expression__T__term__or_op__term:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));                    
                    break;
                case tree::simple_expression__T__literal_string:
                    //to do
                    break;
            }
            break;
        }
        case tree::T_TERM:{     //pid 81~82
            switch (node->get_pid()){
                case tree::term__T__factor:
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::term__T__term__mulop__factor:
                    generate_by_pid(node->get_child(0));
                    generate_by_pid(node->get_child(1));
                    generate_by_pid(node->get_child(2));   
                    break; 
            }
            break;
        }
        case tree::T_FACTOR:{       //pid 83~88
            switch (node->get_pid()){
                case tree::factor__T__leftparen__expression__rightparen:
                    std::cout << "(";
                    generate_by_pid(node->get_child(1));
                    std::cout << ")";
                    break;
                case tree::factor__T__variable:    //fall through!
                    generate_by_pid(node->get_child(0));
                    break;
                case tree::factor__T__num: 
                    std::cout << node->get_child(0)->get_text();
                    break;
                case tree::factor__T__id__leftparen__expression_list__rightparen:
                    id_process(node->get_child(0), BRACKET);
                    std::cout << "(";
                    generate_by_pid(node->get_child(2));
                    std::cout << ")";
                    break;
                case tree::factor__T__notop__factor:
                    std::cout << "!(";
                    generate_by_pid(node->get_child(1));
                    std::cout << ")";
                    break;
                case tree::factor__T__subop__factor:
                    std::cout << "-(";
                    generate_by_pid(node->get_child(1));
                    std::cout << ")";
                    break;
            }
            break;
        }
        case tree::T_INTEGER:
            std::cout << "int";
            break;       
        case tree::T_CHAR:
            std::cout << "char";
            break;         
        case tree::T_BOOLEAN:
            std::cout << "bool";
            break; 
        case tree::T_DOUBLE:
            std::cout << "double";
            break;               
        case tree::T_QUATEOP:
            std::cout << "==";
            break;
        case tree::T_LITERAL_INT:
            std::cout << "int";
            break;
        case tree::T_LITERAL_BOOL:
            std::cout << "bool";
            break;
        case tree::T_STRING:
            std::cout << "std::string";
            break;
        case tree::T_LONGINT:
            std::cout << "long int";
            break;
        case tree::T_LITERAL_CHAR:
            std::cout << node->get_text();
            break;
        default:
            std::cout << "ERROR: " << node->get_token() << std::endl;
            break;
    }
    return true;
}
bool generate_code(){
    std::cout << "#include <stdio.h>" << std::endl;
    std::cout << "#include <stdlib.h>" << std::endl;
    std::cout << "#include <stdbool.h>" << std::endl;
    // assert(symbol_table_tree.root == symbol_table_tree.current_node);
    return generate_by_pid(tree::ast->get_root());
}

}