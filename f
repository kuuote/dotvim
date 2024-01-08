#!/bin/bash -u

cd $(dirname $0) || exit 1
rm -rf /tmp/inline.vim
if echo "$@" | grep -q rm; then
  rm -rf /tmp/dpp
else
  shopt -s globstar
  rm -rf /tmp/dpp/**/cache.vim
  rm -rf /tmp/dpp/**/state.vim
  find /tmp/dpp | grep 
fi
vim -u vimrc
nvim -u vimrc
