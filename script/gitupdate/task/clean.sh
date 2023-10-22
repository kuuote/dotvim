#!/bin/bash -u

cd $1
[[ -e .vimrc_hash ]] && exit
[[ ! -e .git ]] && exit
ls -1A --color=never | grep -v '^\.git$' | xargs rm -rf
git restore .
/data/vim/repos/github.com/WayneD/rsync/support/git-set-file-times
