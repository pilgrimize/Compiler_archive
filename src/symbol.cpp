#include "symbol.h"

namespace symbol {

SymbolTableTree symbol_table_tree;

TypeCategory get_type_category(BasicType type) {
    switch (type) {
        case TYPE_NULL: return TYPE_CATEGORY_NULL;
        case TYPE_INT: case TYPE_LONGINT: case TYPE_SHORTINT: case TYPE_BYTE: return TYPE_CATEGORY_INT;
        case TYPE_FLOAT: case TYPE_SINGLE: case TYPE_DOUBLE: return TYPE_CATEGORY_FLOAT;
        case TYPE_BOOL: return TYPE_CATEGORY_BOOL;
        case TYPE_CHAR: return TYPE_CATEGORY_CHAR;
        case TYPE_STRING: return TYPE_CATEGORY_STRING;
    }
}

void SymbolTableTree::initialize() {
    root = std::make_shared<SymbolTableNode>();
    current_node = root;
}

void SymbolTableTree::push_scope(BasicType return_type, const std::string& scope_name) {
    auto new_node = std::make_shared<SymbolTableNode>(current_node, scope_name);
    current_node->add_child(new_node);
    current_node = new_node;
    if (return_type != TYPE_NULL) {  // Add the return value of the function
        add_entry(scope_name, std::make_shared<SymbolTableEntry>(return_type, false, false));
    }
}

void SymbolTableTree::pop_scope() {
    if (current_node->get_parent() == nullptr) {
        throw std::runtime_error("Cannot pop global scope");
    }
    current_node = current_node->get_parent();
}

void SymbolTableTree::next_scope() {
    current_node = current_node->next_child();
}

SymbolTableTree::SearchResult SymbolTableTree::search_entry(const std::string &name, bool ignore_scope_name) {
    auto node = current_node;
    while (node != nullptr) {
        if (node->has_entry(name)) {
            if (ignore_scope_name && node->get_scope_name() == name) {
                node = node->get_parent();
                continue;
            }
            if (node == current_node) {
                return FOUND;
            } else {
                return FOUND_IN_ANCESTOR;
            }
        }
        node = node->get_parent();
    }
    return NOT_FOUND;
}

// Get the entry with the given name, from the current scope to the root scope
std::shared_ptr<SymbolTableEntry> SymbolTableTree::get_entry(const std::string& name, bool ignore_scope_name) {
    auto node = current_node;
    while (node != nullptr) {
        if (node->has_entry(name)) {
            if (ignore_scope_name && node->get_scope_name() == name) {
                node = node->get_parent();
                continue;
            }
            return node->get_entry(name);
        }
        node = node->get_parent();
    }
    throw std::runtime_error("Cannot find entry " + name);
}

void SymbolTableTree::add_entry(const std::string &name, const std::shared_ptr<SymbolTableEntry> &entry) {
    current_node->add_entry(name, entry);
}

}