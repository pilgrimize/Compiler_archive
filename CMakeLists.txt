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
MACRO(SUBDIR_LIST result src_dir)
    FILE(GLOB children RELATIVE ${src_dir} ${src_dir}/*)
    SET(dirlist "")
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${src_dir}/${child})
            LIST(APPEND dirlist ${child})
        ENDIF()
    ENDFOREACH()
    SET(${result} ${dirlist})
ENDMACRO()

enable_testing()

find_program(DEBUG_SCRIPT NAMES debug.sh HINTS ${CMAKE_CURRENT_SOURCE_DIR}/test/ REQUIRED)
find_program(TEST_SCRIPT NAMES test.sh HINTS ${CMAKE_CURRENT_SOURCE_DIR}/test/ REQUIRED)

set(CASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/test/cases)

add_test(
        NAME debug_test
        COMMAND ${DEBUG_SCRIPT} $<TARGET_FILE:pascals-to-c> ${CASE_DIR}/case-type-test.pas
)

FOREACH(test_type final lexical syntax semantic codegen)
    SUBDIR_LIST(${test_type}_src ${CASE_DIR}/${test_type})
    FOREACH(subdir ${${test_type}_src})
        add_test(
                NAME ${test_type}_${subdir}
                COMMAND ${TEST_SCRIPT} $<TARGET_FILE:pascals-to-c> ${subdir} ${CASE_DIR}/${test_type}/${subdir} ${CMAKE_CURRENT_BINARY_DIR}/test/${test_type}/${subdir}
        )
    ENDFOREACH()
ENDFOREACH()
