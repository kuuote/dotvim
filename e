#!/bin/bash -u

# よくよく考えた毎回暖かみのある手作業で起動しているのは無駄なわけでありまして
# 自動化してしまいましょうの巻

clear
if [[ ${link_dotvim:-} != 1 ]]; then
  rm -rf /tmp/dpp
  rm -rf ~/.vim
  rm -rf ~/.config/nvim
  ln -s $(realpath .) ~/.vim
  ln -s $(realpath .) ~/.config/nvim
fi
nvim
[[ $? != 0 ]] && exit
link_dotvim=1 exec $0
