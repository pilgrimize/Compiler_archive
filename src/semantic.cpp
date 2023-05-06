#include "semantic.h"
#include <algorithm>
#include <iostream>

namespace semantic {

symbol::SymbolTableTree symbol_table_tree;

using symbol::BasicType, symbol::SymbolTableEntry, symbol::SymbolTableTree;
using tree::TreeNode;

// Check if two types match
bool check_type(BasicType type_a, BasicType type_b, int check_mode = 0) {
    switch (check_mode) {
        case 0: // assignment
            if (type_a == type_b || (type_a == symbol::TYPE_FLOAT && type_b == symbol::TYPE_INT)) return true;
            std::cerr << "Error: type mismatched for assignment" << std::endl;
            return false;
        default:
            return false;
    }
}

bool check_id(TreeNode* node, bool expect_basic = true, bool expect_not_constant = false, bool ignore_scope_name = false) {
    auto id_text = node->get_text();
    if (symbol_table_tree.search_entry(id_text, ignore_scope_name) == SymbolTableTree::NOT_FOUND) {
        std::cerr << "Error: '" << id_text << "' is not defined" << std::endl;
        return false;
    } else if(expect_basic){
        auto entry = symbol_table_tree.get_entry(id_text);
        if (entry->type != symbol::TYPE_BASIC) {
            std::cerr << "Error: '" << id_text << "' is not a basic type" << std::endl;
            return false;
        } else {
            auto type_info = std::get<symbol::BasicInfo>(entry->extra_info);
            if (expect_not_constant && type_info.is_const) {
                std::cerr << "Error: '" << id_text << "' is a constant, which cannot be assigned" << std::endl;
                return false;
            }
        }
    }
    return true;
}

// Get the basic type of a id, guaranteed to be a basic type
BasicType get_basic_id_type(TreeNode* node) {
    return std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(node->get_text())->extra_info).basic;
}

// Get if a id is a constant, guaranteed to be a basic type
bool is_id_constant(TreeNode* node) {
    return std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(node->get_text())->extra_info).is_const;
}

bool is_variable_assignable(TreeNode* node) {
    // a variable can be assigned if it is not a constant and it is not a function call
    auto id_text = node->get_child(0)->get_text();
    if (node->get_children().size() == 2) {
        return !std::get<symbol::ArrayInfo>(symbol_table_tree.get_entry(id_text)->extra_info).is_const;
    } else {
        return id_text == symbol_table_tree.get_scope_name() || !std::get<symbol::BasicInfo>(symbol_table_tree.get_entry(id_text)->extra_info).is_const;
    }
}

BasicType get_const_type(TreeNode* node) {
    auto token = node->get_children().back()->get_token();
    switch (token) {
        case tree::T_LITERAL_INT: return symbol::TYPE_INT;
        case tree::T_LITERAL_REAL: return symbol::TYPE_FLOAT;
        case tree::T_LITERAL_CHAR: return symbol::TYPE_CHAR;
        case tree::T_LITERAL_BOOL: return symbol::TYPE_BOOL;
        default: return symbol::TYPE_NULL;
    }
}

BasicType get_basic_type(TreeNode* node) {
    if (node == nullptr) return symbol::TYPE_NULL;
    auto token = node->get_child(0)->get_token();
    switch (token) {
        case tree::T_INTEGER: return symbol::TYPE_INT;
        case tree::T_REAL: return symbol::TYPE_FLOAT;
        case tree::T_CHAR: return symbol::TYPE_CHAR;
        case tree::T_BOOLEAN: return symbol::TYPE_BOOL;
        default: return symbol::TYPE_NULL;
    }
}

std::vector<std::string> get_id_list(TreeNode* node) {
    std::vector<std::string> id_list;
    if (node->get_pid() == 12) { // id
        id_list.emplace_back(node->get_child(0)->get_text());
    } else if (node->get_pid() == 3) { // id_list
        id_list = get_id_list(node->get_child(0));
        id_list.emplace_back(node->get_child(2)->get_text());
    }
    return id_list;
}

std::vector<std::pair<size_t, size_t>> get_dims(TreeNode* node) {
    std::vector<std::pair<size_t, size_t>> dims;
    if (node->get_pid() == 29) { // dim
        dims.emplace_back(
                std::stoul(node->get_child(0)->get_text()),
                std::stoul(node->get_child(2)->get_text()));
    } else if (node->get_pid() == 30) { // dim_list
        dims = get_dims(node->get_child(0));
        dims.emplace_back(
                std::stoul(node->get_child(2)->get_text()),
                std::stoul(node->get_child(4)->get_text()));
    }
    return dims;
}

std::pair<std::vector<std::string>, symbol::Param> get_single_param(TreeNode* node) {
    bool is_referred = node->get_token() == tree::T_VAR_PARAMETER;
    auto param_node = is_referred ? node->get_child(0)->get_child(1) : node->get_child(0);
    auto id_list = get_id_list(param_node->get_child(0));
    auto type = get_basic_type(param_node->get_child(2));
    return {id_list, symbol::Param(type, is_referred)};
}

std::vector<std::pair<std::string, symbol::Param>> get_params(TreeNode* node) {
    std::vector<std::pair<std::string, symbol::Param>> params;
    if (node->get_pid() == 39) { // param
        auto [id_list, param] = get_single_param(node->get_child(0));
        for (auto& id : id_list) {
            params.emplace_back(id, param);
        }
    } else if (node->get_pid() == 40) { // param_list
        params = get_params(node->get_child(0));
        auto [id_list, param] = get_single_param(node->get_child(2));
        for (auto& id : id_list) {
            params.emplace_back(id, param);
        }
    }
    return params;
}

std::shared_ptr<SymbolTableEntry> get_type(TreeNode* node) {
    auto token = node->get_child(0)->get_token();
    switch (token) {
        case tree::T_BASIC_TYPE:
            return std::make_shared<SymbolTableEntry>(get_basic_type(node->get_child(0)));
        case tree::T_ARRAY: {
            auto basic_type = get_basic_type(node->get_child(5));
            auto dims = get_dims(node->get_child(2));
            return std::make_shared<SymbolTableEntry>(basic_type, dims);
        }
        default:
            return {};
    }
}

std::vector<BasicType> get_expression_list_type(TreeNode* node) {
    std::vector<BasicType> types;
    if (node->get_pid() == 73) { // expression
        types.emplace_back(node->get_child(0)->get_type());
    } else if (node->get_pid() == 73) { // expression_list
        types = get_expression_list_type(node->get_child(0));
        types.emplace_back(node->get_child(2)->get_type());
    }
    return types;
}

bool dfs_analyze_node(TreeNode* node) {
    int delta = -1;
    // Enter the node
    switch (node->get_pid()) {
        case 1: // program
            symbol_table_tree.initialize();
            break;
        case 15: // const declaration
            delta = 0;
        case 16: {
            // const declaration
            if (delta < 0) delta = 2;
            auto text = node->get_child(delta + 0)->get_text();
            if (symbol_table_tree.search_entry(text)) {
                std::cerr << "Error: redefinition of '" << text << "'" << std::endl;
                return false;
            }
            auto initialize_value = node->get_child(delta + 2)->get_text();
            auto entry = std::make_shared<SymbolTableEntry>(
                    get_const_type(node->get_child(delta + 2)), true);
            symbol_table_tree.add_entry(text, entry);
            break;
        }
        case 22: // var declaration
            delta = 0;
        case 23: {
            // var declaration
            if (delta < 0) delta = 2;
            auto id_list = get_id_list(node->get_child(delta + 0));
            auto entry = get_type(node->get_child(delta + 2));
            for (auto& id : id_list) {
                if (symbol_table_tree.search_entry(id)) {
                    std::cerr << "Error: redefinition of '" << id << "'" << std::endl;
                    return false;
                }
                symbol_table_tree.add_entry(id, entry);
            }
            break;
        }
        case 34: case 35: case 36: case 37: {
            auto function_id = node->get_child_by_token(tree::T_ID)->get_text();
            if (symbol_table_tree.search_entry(function_id) == SymbolTableTree::FOUND) {
                std::cerr << "Error: redefinition of '" << function_id << "'" << std::endl;
                return false;
            }
            auto param_node = node->get_child_by_token(tree::T_FORMAL_PARAMETER)->get_child(1);
            auto return_type = get_basic_type(node->get_child_by_token(tree::T_BASIC_TYPE));
            auto params = param_node == nullptr ? std::vector<std::pair<std::string, symbol::Param>>{} : get_params(param_node);
            std::vector<symbol::Param> param_types;
            for (auto& [id, param] : params) {
                param_types.emplace_back(param);
            }
            symbol_table_tree.add_entry(function_id, std::make_shared<SymbolTableEntry>(return_type, param_types));
            symbol_table_tree.push_scope(return_type, function_id);
            for (auto& [id, param] : params) {
                if (symbol_table_tree.search_entry(id) == SymbolTableTree::FOUND) {
                    std::cerr << "Error: redefinition of '" << id << "'" << std::endl;
                    return false;
                }
                symbol_table_tree.add_entry(id, std::make_shared<SymbolTableEntry>(param.type, false, param.is_referred));
            }
            break;
        }
        default:
            break;
    }

    auto result = std::ranges::all_of(node->children_begin(), node->children_end(), [](auto child){return dfs_analyze_node(child);});
    if (!result) return false;

    // Exit the node
    switch (node->get_pid()) {
        case 33:
            symbol_table_tree.pop_scope();
            break;
        case 52: case 53: {
            // assign
            if (!is_variable_assignable(node->get_child(0))) {
                std::cerr << "Error: cannot assign to a right value or a constant" << std::endl;
                return false;
            }
            auto left_type = node->get_child(0)->get_type();
            auto right_type = node->get_child(2)->get_type();
            if (!check_type(left_type, right_type, 0)) return false;
            break;
        }
        case 56: case 57: case 58: {
            // condition and loop
            auto expression_type = node->get_child_by_token(tree::T_EXPRESSION)->get_type();
            if (expression_type != symbol::TYPE_BOOL) {
                std::cerr << "Error: expected boolean type for condition, found others" << std::endl;
                return false;
            }
            break;
        }
        case 59: case 60: {
            // for loop
            auto id_node = node->get_child(1);
            if (!check_id(id_node, true, true)) return false;
            auto id_type = get_basic_id_type(id_node);
            if (id_type != symbol::TYPE_INT || node->get_child(3)->get_type() != symbol::TYPE_INT || node->get_child(3)->get_type() != symbol::TYPE_INT) {
                std::cerr << "Error: expected integer type for for-loop index, found others" << std::endl;
                return false;
            }
            break;
        }
        case 65: {
            // id as variable
            auto id_text = node->get_child(0)->get_text();
            if (id_text == symbol_table_tree.get_scope_name()) {
                auto func_entry = symbol_table_tree.get_entry(id_text, true);
                node->set_type(std::get<symbol::FunctionInfo>(func_entry->extra_info).ret_type);
            } else {
                if (!check_id(node->get_child(0), false, false)) return false;
                auto entry = symbol_table_tree.get_entry(id_text);
                if (entry->type == symbol::TYPE_BASIC) {
                    node->set_type(std::get<symbol::BasicInfo>(entry->extra_info).basic);
                } else if (entry->type == symbol::TYPE_FUNCTION){
                    auto info = std::get<symbol::FunctionInfo>(entry->extra_info);
                    if (info.ret_type == symbol::TYPE_NULL) {
                        std::cerr << "Error: '" << id_text << "' is not a function" << std::endl;
                        return false;
                    }
                    if (!info.params.empty()) {
                        std::cerr << "Error: parameter mismatched for function '" << id_text << "'" << std::endl;
                        return false;
                    }
                    node->set_type(info.ret_type);
                }
                break;
            }

        }
        case 66: {
            // array element as variable
            auto id_text = node->get_child(0)->get_text();
            if (!check_id(node->get_child(0), false, false)) return false;
            auto entry = symbol_table_tree.get_entry(id_text);
            if (entry->type != symbol::TYPE_ARRAY) {
                std::cerr << "Error: '" << id_text << "' is not an array" << std::endl;
                return false;
            }
            auto info = std::get<symbol::ArrayInfo>(entry->extra_info);
            auto index_list = get_expression_list_type(node->get_child(1)->get_child(1));
            if (index_list.size() != info.dims.size()) {
                std::cerr << "Error: dimension mismatched for array '" << id_text << "'" << std::endl;
                return false;
            }
            for (auto type: index_list) {
                if (type != symbol::TYPE_INT) {
                    std::cerr << "Error: expected integer type for array index, found others" << std::endl;
                    return false;
                }
            }
            node->set_type(info.basic);
            break;
        }
        case 68: {
            // procedure call
            auto id_text = node->get_child(0)->get_text();
            if (!check_id(node->get_child(0), false, false)) return false;
            auto entry = symbol_table_tree.get_entry(id_text);
            if (entry->type != symbol::TYPE_FUNCTION) {
                std::cerr << "Error: '" << id_text << "' is not a procedure" << std::endl;
                return false;
            }
            auto info = std::get<symbol::FunctionInfo>(entry->extra_info);
            if (info.ret_type != symbol::TYPE_NULL) {
                std::cerr << "Error: '" << id_text << "' is not a procedure" << std::endl;
                return false;
            }
            auto param_list = get_expression_list_type(node->get_child(2));
            if (param_list.size() != info.params.size()) {
                std::cerr << "Error: parameter mismatched for procedure '" << id_text << "'" << std::endl;
                return false;
            }
            for (int i = 0; i < param_list.size(); ++i) {
                if (!check_type(param_list[i], info.params[i].type, 0)) {
                    std::cerr << "Error: type mismatched for parameter '" << i << "' of procedure '" << id_text << "'" << std::endl;
                    return false;
                }
            }
            break;
        }
        case 69: {
            // procedure call
            if (!check_id(node->get_child(0), false, false)) return false;
            auto entry = symbol_table_tree.get_entry(node->get_child(0)->get_text());
            if (entry->type != symbol::TYPE_FUNCTION) {
                std::cerr << "Error: '" << node->get_child(0)->get_text() << "' is not a procedure" << std::endl;
                return false;
            }
            auto info = std::get<symbol::FunctionInfo>(entry->extra_info);
            if (info.ret_type != symbol::TYPE_NULL) {
                std::cerr << "Error: '" << node->get_child(0)->get_text() << "' is not a procedure" << std::endl;
                return false;
            }
            if (!info.params.empty()) {
                std::cerr << "Error: parameter mismatched for procedure '" << node->get_child(0)->get_text() << "'" << std::endl;
                return false;
            }
            break;
        }
        case 74: case 77: case 81: case 84: {
            node->set_type(node->get_child(0)->get_type());
            break;
        }
        case 75: case 76: {
            auto type_a = node->get_child(0)->get_type();
            auto type_b = node->get_child(2)->get_type();
            if (!((type_a == symbol::TYPE_INT || type_a == symbol::TYPE_FLOAT) && (type_b == symbol::TYPE_INT || type_b == symbol::TYPE_FLOAT))) {
                std::cerr << "Error: expected integer or real type for comparison, found others" << std::endl;
                return false;
            }
            node->set_type(symbol::TYPE_BOOL);
            break;
        }
        case 78: case 79: case 82: {
            auto type_a = node->get_child(0)->get_type();
            auto type_b = node->get_child(2)->get_type();
            if (!((type_a == symbol::TYPE_INT || type_a == symbol::TYPE_FLOAT) && (type_b == symbol::TYPE_INT || type_b == symbol::TYPE_FLOAT))) {
                std::cerr << "Error: expected integer or real type for arithmetic operation, found others" << std::endl;
                return false;
            }
            node->set_type(type_a == symbol::TYPE_INT && type_b == symbol::TYPE_INT ? symbol::TYPE_INT : symbol::TYPE_FLOAT);
            break;
        }
        case 80: {
            auto type_a = node->get_child(0)->get_type();
            auto type_b = node->get_child(2)->get_type();
            if (!(type_a == symbol::TYPE_INT && type_b == symbol::TYPE_INT)) {
                std::cerr << "Error: expected integer type for bit operation, found others" << std::endl;
                return false;
            }
            node->set_type(symbol::TYPE_INT);
            break;
        }
        case 83: {
            node->set_type(node->get_child(1)->get_type());
            break;
        }
        case 85: {
            // function call
            if (!check_id(node->get_child(0), false, false, true)) return false;
            auto entry = symbol_table_tree.get_entry(node->get_child(0)->get_text(), true);
            if (entry->type != symbol::TYPE_FUNCTION) {
                std::cerr << "Error: '" << node->get_child(0)->get_text() << "' is not a function" << std::endl;
                return false;
            }
            auto info = std::get<symbol::FunctionInfo>(entry->extra_info);
            if (info.ret_type == symbol::TYPE_NULL) {
                std::cerr << "Error: '" << node->get_child(0)->get_text() << "' is not a function" << std::endl;
                return false;
            }
            auto param_list = get_expression_list_type(node->get_child(2));
            for (int i = 0; i < param_list.size(); ++i) {
                if (!check_type(param_list[i], info.params[i].type, 0)) {
                    std::cerr << "Error: type mismatched for parameter '" << i << "' of function '" << node->get_child(0)->get_text() << "'" << std::endl;
                    return false;
                }
            }
            node->set_type(info.ret_type);
            break;
        }
        case 86: {
            node->set_type(symbol::TYPE_INT);
            break;
        }
        case 87: {
            auto type = node->get_child(1)->get_type();
            if (type != symbol::TYPE_INT) {
                std::cerr << "Error: expected integer type for not operation, found others" << std::endl;
                return false;
            }
            node->set_type(symbol::TYPE_INT);
            break;
        }
        case 88: {
            auto type = node->get_child(1)->get_type();
            if (!(type == symbol::TYPE_INT || type == symbol::TYPE_FLOAT)) {
                std::cerr << "Error: expected integer or real type for minus operation, found others" << std::endl;
                return false;
            }
            node->set_type(type);
            break;
        }
        default:
            break;
    }

    return true;
}

// Semantic analysis and construction of the symbol table, returns true if no errors were found
// TODO: implement this function
bool semantic_analysis() {
    return dfs_analyze_node(tree::ast->get_root());
}

}
