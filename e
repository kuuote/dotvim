#!/bin/bash -u

exec nvim -u $(dirname $0)/vimrc "$@"
