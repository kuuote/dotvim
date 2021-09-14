#!/bin/bash -eux

mkdir parser
clang++ -fPIC -shared -o parser/lua.so -Isrc src/parser.c src/scanner.cc
rm -rf src
