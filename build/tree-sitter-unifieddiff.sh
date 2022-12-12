#!/bin/bash -eux

mkdir parser
clang -fPIC -shared -o parser/unifieddiff.so -Isrc src/parser.c src/scanner.c
