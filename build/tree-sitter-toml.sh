#!/bin/bash -eux

rm -rf tree-sitter/cli
mkdir parser
clang -fPIC -shared -o parser/toml.so -Isrc src/parser.c src/scanner.c
