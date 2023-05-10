#!/bin/bash

EXECUTABLE=$1
TEST_NAME=$2
SOURCE_DIR=$3
TEMP_OUTPUT_DIR=$4

mkdir -p "$SOURCE_DIR"
mkdir -p "$TEMP_OUTPUT_DIR"

INPUT_FILE="$SOURCE_DIR/$TEST_NAME.pas"
EXPECTED_OUTPUT="$SOURCE_DIR/$TEST_NAME.c"
EXPECTED_LOG="$SOURCE_DIR/$TEST_NAME.log"
OUTPUT="$TEMP_OUTPUT_DIR/$TEST_NAME.c"
LOG="$TEMP_OUTPUT_DIR/$TEST_NAME.log"

touch "$EXPECTED_LOG"
touch "$EXPECTED_OUTPUT"

$EXECUTABLE -i "$INPUT_FILE" -o "$OUTPUT" -l "$LOG"

if diff -u "$EXPECTED_OUTPUT" "$OUTPUT" > /dev/null && diff -u "$EXPECTED_LOG" "$LOG" > /dev/null; then
  exit 0
else
  exit 1
fi
