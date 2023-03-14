cmake_minimum_required(VERSION 3.16)
project(pascals-to-c)
set(CMAKE_CXX_STANDARD 20)


# lex and yacc
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

FLEX_TARGET(scanner ./src/scanner.l ${CMAKE_CURRENT_BINARY_DIR}/scanner.cpp
        DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/scanner.h)
BISON_TARGET(parser ./src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
        DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.h)
ADD_FLEX_BISON_DEPENDENCY(scanner parser)

include_directories(${CMAKE_CURRENT_BINARY_DIR})


# main code
include_directories(./include)
aux_source_directory(./src SRC)

add_executable(pascals-to-c ${SRC} ${FLEX_scanner_OUTPUTS} ${BISON_parser_OUTPUTS})


# test
enable_testing()

add_executable(final_test ./test/final_test.cpp)

add_test(
        NAME final_test
        COMMAND $<TARGET_FILE:final_test>
)