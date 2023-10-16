#!/bin/bash -u

deno run -A script/time/time.ts script/time/time.sh
rm -f /tmp/profile
nvim --cmd 'profile start /tmp/profile' --cmd 'profile file *' -u vimrc +q
