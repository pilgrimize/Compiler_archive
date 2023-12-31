#!/bin/bash

EXECUTABLE=$1
TEST_NAME=$2
SOURCE_DIR=$3
EXPECTED_OUTPUT_DIR=$4
TEMP_OUTPUT_DIR=$5


mkdir -p "$EXPECTED_OUTPUT_DIR"
mkdir -p "$TEMP_OUTPUT_DIR"

INPUT_FILE="$SOURCE_DIR/$TEST_NAME.pas"
INPUT_DATA="$SOURCE_DIR/$TEST_NAME.in"
EXPECTED_OUTPUT="$EXPECTED_OUTPUT_DIR/$TEST_NAME.out"
C_OUTPUT="$TEMP_OUTPUT_DIR/$TEST_NAME.c"
C_EXECUTABLE="$TEMP_OUTPUT_DIR/$TEST_NAME"
OUTPUT="$TEMP_OUTPUT_DIR/$TEST_NAME.out"
LOG="$TEMP_OUTPUT_DIR/$TEST_NAME.log"

touch "$EXPECTED_OUTPUT"

$EXECUTABLE -i "$INPUT_FILE" -o "$C_OUTPUT" -l "$LOG"
gcc -o "$C_EXECUTABLE" "$C_OUTPUT"
"$C_EXECUTABLE" < "$INPUT_DATA" > "$OUTPUT"

if diff -u "$EXPECTED_OUTPUT" "$OUTPUT" > /dev/null; then
  exit 0
else
  exit 1
fi
