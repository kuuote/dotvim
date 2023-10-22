#!/bin/bash -u

exec vim -u $(dirname $0)/vimrc "$@"
