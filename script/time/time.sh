#!/usr/bin/env bash
set -euo pipefail

cd $(dirname $0)
cd ../..
nvim -u vimrc --headless --startuptime $1 -c "autocmd VimEnter * call timer_start(0, {...->execute('cquit')})"
