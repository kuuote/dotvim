#!/bin/bash -u

proc() {
  cp "deps/${1}.mts" "../${1}.ts"
  ./molt -w "../${1}.ts"
  deno cache "../${1}.ts"
}

./init

proc deno_std
