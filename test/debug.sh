#!/bin/bash

EXECUTABLE=$1
INPUT_FILE=$2

if $EXECUTABLE -i "$INPUT_FILE" -l debug.log -o debug.c; then
  exit 0
else
  exit 1
fi
