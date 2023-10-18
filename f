#!/bin/bash -u

cd $(dirname $0) || exit 1
rm -rf /tmp/inline.vim
rm -rf /tmp/dpp
# dpp_force_makestate=1 vim -u vimrc
vim -u vimrc
nvim -u vimrc
