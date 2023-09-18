#!/bin/bash -u

cd $1
[[ -e .vimrc_hash ]] && exit
[[ ! -e .git ]] && exit
git clean -ffdx
git restore .
