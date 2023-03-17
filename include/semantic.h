#ifndef PASCALS_TO_C_SEMANTIC_H
#define PASCALS_TO_C_SEMANTIC_H

#include "tree.h"
#include "symbol.h"

namespace semantic {

// Semantic analysis and construction of the symbol table, returns true if no errors were found
bool semantic_analysis();

}

#endif //PASCALS_TO_C_SEMANTIC_H
