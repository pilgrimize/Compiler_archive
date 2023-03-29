#include "semantic.h"
#include <algorithm>
#include <iostream>

namespace semantic {

symbol::SymbolTableTree symbol_table_tree;

using symbol::BasicType, symbol::SymbolTableEntry;
using tree::TreeNode;


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

bool dfs_analyze_node(TreeNode* node) {
    int delta = -1;
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
            if (symbol_table_tree.find_entry(text)) {
                std::cerr << "Error: redefinition of '" << text << "'\n";
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
            // const declaration
            if (delta < 0) delta = 2;
            auto id_list = get_id_list(node->get_child(delta + 0));
            auto entry = get_type(node->get_child(delta + 2));
            for (auto& id : id_list) {
                if (symbol_table_tree.find_entry(id)) {
                    std::cerr << "Error: redefinition of '" << id << "'\n";
                    return false;
                }
                symbol_table_tree.add_entry(id, entry);
            }
        }


        default:
            break;
    }

    return std::ranges::all_of(node->children_begin(), node->children_end(), [](auto child){return dfs_analyze_node(child);});
}

// Semantic analysis and construction of the symbol table, returns true if no errors were found
// TODO: implement this function
bool semantic_analysis() {
    return dfs_analyze_node(tree::ast->get_root());
    // if (!tree::cst_to_ast(stack::ast_stack.top())) return false;
    // return true;
}

}
