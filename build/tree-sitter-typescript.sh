#!/bin/bash -eux

mkdir parser
clang -fPIC -shared -o parser/typescript.so -Itypescript/src typescript/src/parser.c typescript/src/scanner.c
clang -fPIC -shared -o parser/tsx.so -Itsx/src tsx/src/parser.c tsx/src/scanner.c
rm -rf typescript
rm -rf tsx
