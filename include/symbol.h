#ifndef PASCALS_TO_C_SYMBOL_H
#define PASCALS_TO_C_SYMBOL_H

#include <string>
#include <utility>
#include <vector>
#include <memory>
#include <map>
#include <variant>

namespace symbol {

enum BasicType {
    TYPE_NULL = -1,
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_CHAR,
    TYPE_BOOL,
    TYPE_STRING,
    TYPE_SINGLE,
    TYPE_DOUBLE,
    TYPE_SHORTINT,
    TYPE_LONGINT,
    TYPE_BYTE,
};

enum TypeCategory {
    TYPE_CATEGORY_NULL = -1,
    TYPE_CATEGORY_INT,
    TYPE_CATEGORY_FLOAT,
    TYPE_CATEGORY_CHAR,
    TYPE_CATEGORY_BOOL,
    TYPE_CATEGORY_STRING,
};

TypeCategory get_type_category(BasicType type);

enum ComplexType {
    TYPE_BASIC,
    TYPE_ARRAY,
    TYPE_RECORD,
    TYPE_FUNCTION,
};

struct Param {
    BasicType type{};
    bool is_referred = false;
    Param() = default;
    Param(BasicType type, bool is_referred):
            type(type), is_referred(is_referred) {}
};
struct BasicInfo {
    BasicType basic{};
    bool is_const = false;
    bool is_referred = false;
    BasicInfo() = default;
    BasicInfo(BasicType basic, bool is_const, bool is_referred):
            basic(basic), is_const(is_const), is_referred(is_referred) {}
};
struct ArrayInfo {
    BasicType basic{};
    std::vector<std::pair<size_t,size_t>> dims;
    bool is_const = false;
    ArrayInfo() = default;
    ArrayInfo(BasicType basic, std::vector<std::pair<size_t,size_t>> dims, bool is_const):
            basic(basic), dims(std::move(dims)), is_const(is_const) {}
};
struct RecordInfo {
    std::map<std::string, BasicType> fields;
    RecordInfo() = default;
    explicit RecordInfo(std::map<std::string, BasicType> fields):
            fields(std::move(fields)) {}
};
struct FunctionInfo {
    BasicType ret_type{};
    std::vector<Param> params;
    FunctionInfo() = default;
    FunctionInfo(BasicType ret_type, std::vector<Param> params):
            ret_type(ret_type), params(std::move(params)) {}
};
typedef std::variant<std::monostate, BasicInfo, ArrayInfo, RecordInfo, FunctionInfo> ExtraInfo;

// variable, array, record, function
struct SymbolTableEntry {
    ComplexType type{};
    ExtraInfo extra_info;

    SymbolTableEntry() = default;
    SymbolTableEntry(ComplexType type, ExtraInfo extra_info):
            type(type), extra_info(std::move(extra_info)) {}
    explicit SymbolTableEntry(BasicType type, bool is_const = false, bool is_referred = false):
            type(ComplexType::TYPE_BASIC), extra_info(BasicInfo(type, is_const, is_referred)) {}
    SymbolTableEntry(BasicType type, std::vector<std::pair<size_t,size_t>> dims, bool is_const = false):
            type(ComplexType::TYPE_ARRAY), extra_info(ArrayInfo(type, std::move(dims), is_const)) {}
    explicit SymbolTableEntry(std::map<std::string, BasicType> fields):
            type(ComplexType::TYPE_RECORD), extra_info(RecordInfo(std::move(fields))) {}
    SymbolTableEntry(BasicType ret_type, std::vector<Param> params):
            type(ComplexType::TYPE_FUNCTION), extra_info(FunctionInfo(ret_type, std::move(params))) {}
};

class SymbolTableNode {
private:
    std::shared_ptr<SymbolTableNode> parent;
    std::vector<std::shared_ptr<SymbolTableNode>> children;
    std::map<std::string, std::shared_ptr<SymbolTableEntry>> entries;
    std::string scope_name;
    std::vector<std::shared_ptr<SymbolTableNode>> traverse_sequence;

public:
    SymbolTableNode() = default;
    SymbolTableNode(std::shared_ptr<SymbolTableNode> parent, std::string scope_name) :
            parent(std::move(parent)), scope_name(std::move(scope_name)) {}

    std::shared_ptr<SymbolTableNode> get_parent() const { return parent; }
    void add_child(const std::shared_ptr<SymbolTableNode>& child) { children.emplace_back(child); }
    bool has_entry(const std::string& name) const { return entries.find(name) != entries.end(); }
    std::shared_ptr<SymbolTableEntry> get_entry(const std::string& name) const { return entries.at(name); }
    void add_entry(const std::string& name, const std::shared_ptr<SymbolTableEntry>& entry) { entries.emplace(name, entry); }
    std::string get_scope_name() const { return scope_name; }
    void initialize_traverse_sequence() {
        traverse_sequence = children;
        std::reverse(traverse_sequence.begin(), traverse_sequence.end());
    }
    std::map<std::string, std::shared_ptr<SymbolTableEntry>> get_entries() const { return entries; }
    std::shared_ptr<SymbolTableNode> next_child() {
        if (traverse_sequence.empty()) initialize_traverse_sequence();
        auto next_child = traverse_sequence.back();
        traverse_sequence.pop_back();
        return next_child;
    }
    
};

class SymbolTableTree {
private:
    std::shared_ptr<SymbolTableNode> root;
    std::shared_ptr<SymbolTableNode> current_node;
public:
    SymbolTableTree() = default;

    // Initialize the symbol table tree
    void initialize();

    // Enter a new scope
    void push_scope(BasicType return_type, const std::string& scope_name);

    // Exit the current scope
    void pop_scope();

    // Enter the scope of the next child node
    void next_scope();

    enum SearchResult {
        FOUND,
        NOT_FOUND,
        FOUND_IN_ANCESTOR,
    };

    // Get the current scope name
    std::string get_scope_name() const { return current_node->get_scope_name(); }

    // Search the entry with the given name, from the current scope to the root scope
    SearchResult search_entry(const std::string& name, bool ignore_scope_name = false);

    // Get the entry with the given name, from the current scope to the root scope
    std::shared_ptr<SymbolTableEntry> get_entry(const std::string& name, bool ignore_scope_name = false);

    // Add an entry to the current scope
    void add_entry(const std::string& name, const std::shared_ptr<SymbolTableEntry>& entry);

    std::shared_ptr<SymbolTableNode> get_current_node() const { return current_node; }
};

extern SymbolTableTree symbol_table_tree;

}

#endif //PASCALS_TO_C_SYMBOL_H