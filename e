#!/bin/bash -u

# よくよく考えた毎回暖かみのある手作業で起動しているのは無駄なわけでありまして
# 自動化してしまいましょうの巻

dir=$(realpath $(dirname $0))
clear
rm -rf ~/.vim
rm -rf ~/.config/nvim
ln -s $dir ~/.vim
ln -s $dir ~/.config/nvim
if [[ ${newvim_post:-} != 1 ]]; then
  rm -rf /tmp/dpp
fi
nvim
[[ $? != 0 ]] && exit
newvim_post=1 exec $0
