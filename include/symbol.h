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
};

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
//    bool is_initialized = false;
//    std::string initialized_value;
    BasicInfo() = default;
    BasicInfo(BasicType basic, bool is_const, bool is_referred):
            basic(basic), is_const(is_const), is_referred(is_referred) {}
//    BasicInfo(BasicType basic, bool is_const, bool is_initialized, std::string initialized_value):
//            basic(basic), is_const(is_const), is_initialized(is_initialized), initialized_value(std::move(initialized_value)) {}
};
struct ArrayInfo {
    BasicType basic{};
    std::vector<std::pair<size_t,size_t>> dims;
//    std::vector<std::vector<std::string>> initialized_values;
    bool is_const = false;
//    bool is_initialized = false;
    ArrayInfo() = default;
    ArrayInfo(BasicType basic, std::vector<std::pair<size_t,size_t>> dims, bool is_const):
            basic(basic), dims(std::move(dims)), is_const(is_const) {}
//    ArrayInfo(BasicType basic, std::vector<std::pair<size_t,size_t>> dims, std::vector<std::vector<std::string>> initialized_values, bool is_const, bool is_initialized):
//            basic(basic), dims(std::move(dims)), initialized_values(std::move(initialized_values)), is_const(is_const), is_initialized(is_initialized) {}
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

// Compare if entry_a and entry_b have the same type
bool compare_type(const std::shared_ptr<symbol::SymbolTableEntry>& entry_a, const std::shared_ptr<symbol::SymbolTableEntry>& entry_b);

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
    std::shared_ptr<SymbolTableNode> current_node;
public:
    SymbolTableTree() = default;

    // Initialize the symbol table tree
    void initialize();

    // Enter a new scope
    void push_scope();

    // Exit the current scope
    void pop_scope();

    enum SearchResult {
        FOUND,
        NOT_FOUND,
        FOUND_IN_PARENT,
    };

    // Search the entry with the given name, from the current scope to the root scope
    SearchResult search_entry(const std::string& name);

    // Get the entry with the given name, from the current scope to the root scope
    std::shared_ptr<SymbolTableEntry> get_entry(const std::string& name);

    // Add an entry to the current scope
    void add_entry(const std::string& name, const std::shared_ptr<SymbolTableEntry>& entry);
};

extern SymbolTableTree symbol_table_tree;

}

#endif //PASCALS_TO_C_SYMBOL_H