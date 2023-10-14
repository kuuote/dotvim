#!/bin/bash -u

cd $(dirname $0) || exit 1
rm -rf /tmp/inline.vim
export dpp_force_makestate=1
vim -u vimrc
nvim -u vimrc
