#include "symbol.h"

namespace symbol {

// Compare if entry_a and entry_b have the same type
bool compare_type(const std::shared_ptr<symbol::SymbolTableEntry>& entry_a, const std::shared_ptr<symbol::SymbolTableEntry>& entry_b) {
    if (entry_a->type != entry_b->type) {
        return false;
    }
    switch (entry_a->type) {
        case TYPE_BASIC:
            return std::get<BasicInfo>(entry_a->extra_info).basic == std::get<BasicInfo>(entry_b->extra_info).basic;
        case TYPE_ARRAY:
            return std::get<ArrayInfo>(entry_a->extra_info).basic == std::get<ArrayInfo>(entry_b->extra_info).basic
                && std::get<ArrayInfo>(entry_a->extra_info).dims == std::get<ArrayInfo>(entry_b->extra_info).dims;
        case TYPE_RECORD:
            return std::get<RecordInfo>(entry_a->extra_info).fields == std::get<RecordInfo>(entry_b->extra_info).fields;
        case TYPE_FUNCTION:
            return true;  // Theoretically, we don't need to do this in this project
        default:
            return false;
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