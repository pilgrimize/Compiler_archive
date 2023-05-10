#ifndef PASCALS_TO_C_GENERATE_H
#define PASCALS_TO_C_GENERATE_H

#include "tree.h"
#include "symbol.h"
#include "logger.h"
#include <algorithm>
#include <vector>

namespace generate {

// Generate C code, should always return true given a valid tree and symbol table
bool generate_code();

}

#endif //PASCALS_TO_C_GENERATE_H