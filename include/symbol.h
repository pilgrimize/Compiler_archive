#ifndef PASCALS_TO_C_SYMBOL_H
#define PASCALS_TO_C_SYMBOL_H

#include <string>
#include <utility>
#include <vector>
#include <memory>
#include <map>

namespace symbol {

enum BasicType {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_CHAR,
    TYPE_BOOL,
};

union BasicValue {
    int int_val;
    float float_val;
    char char_val;
    bool bool_val;
};

enum ComplexType {
    TYPE_BASIC,
    TYPE_ARRAY,
    TYPE_RECORD,
    TYPE_FUNCTION,
};

// variable, array, record, function
struct SymbolTableEntry {
    struct RecordEntry {
        std::string name;
        BasicType type;
    };
    struct Param {
        BasicType type;
        bool is_referred = false;
    };

    ComplexType type;
    union {
        struct {
            BasicType basic;
            bool is_const = false;
            bool is_initialized = false;
            BasicValue initialized_value;
        } basic;
        struct {
            BasicType basic;
            std::vector<size_t> dims;
            std::vector<std::vector<BasicValue>> initialized_values;
            bool is_const = false;
            bool is_initialized = false;
        } array;
        struct {
            std::vector<RecordEntry> fields;
        } record;
        struct {
            BasicType ret_type;
            std::vector<Param> params;
        } function;
    } extra_info;
};

class SymbolTableNode {
private:
    std::shared_ptr<SymbolTableNode> parent;
    std::vector<std::shared_ptr<SymbolTableNode>> children;
    std::map<std::string, std::shared_ptr<SymbolTableEntry>> entries;
public:
    SymbolTableNode() = default;
    explicit SymbolTableNode(std::shared_ptr<SymbolTableNode> parent) : parent(std::move(parent)) {}

    std::shared_ptr<SymbolTableNode> get_parent() const { return parent; }
    std::vector<std::shared_ptr<SymbolTableNode>> get_children() const { return children; }
    bool has_entry(const std::string& name) const { return entries.find(name) != entries.end(); }
    std::shared_ptr<SymbolTableEntry> get_entry(const std::string& name) const { return entries.at(name); }
    void add_entry(const std::string& name, const std::shared_ptr<SymbolTableEntry>& entry) { entries.emplace(name, entry); }
};

class SymbolTableTree {
private:
    std::shared_ptr<SymbolTableNode> root;
public:
    SymbolTableTree() = default;
    explicit SymbolTableTree(std::shared_ptr<SymbolTableNode> root) : root(std::move(root)) {}

    std::shared_ptr<SymbolTableNode> get_root() const { return root; }
};

extern SymbolTableTree symbol_table_tree;

}

#endif //PASCALS_TO_C_SYMBOL_H