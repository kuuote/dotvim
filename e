#!/bin/bash -u

cd $(dirname $0) || exit 1
exec nvim -u vimrc
