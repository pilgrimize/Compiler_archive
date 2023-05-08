#!/bin/bash

EXECUTABLE=$1
INPUT_FILE=$2
EXPECTED_OUTPUT=$3

if test -z "$EXPECTED_OUTPUT"; then
  if $EXECUTABLE -i "$INPUT_FILE" -d -l debug.log -o debug.out; then
    exit 0
  else
    exit 1
  fi
fi

if diff -u <($EXECUTABLE -i "$INPUT_FILE" -l /dev/null) "$EXPECTED_OUTPUT" > /dev/null; then
  exit 0
else
  echo 1
fi
