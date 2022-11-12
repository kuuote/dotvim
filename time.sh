#!/bin/bash -u

sudo rm -rf /tmp/time
nvim +q
nvim +q
nvim +q
nvim --startuptime /tmp/time -c 'autocmd VimEnter * call timer_start(0, {...->execute("q")})'
nvim -c 'source ~/.vim/time.vim'
