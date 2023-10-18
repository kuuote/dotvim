#!/bin/bash -u

cd $(dirname $0) || exit 1
rm -rf /tmp/inline.vim
rm -rf /tmp/dpp
vim -u vimrc
nvim -u vimrc
