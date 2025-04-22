#!/usr/bin/env bash
set -euo pipefail

deno run -A script/time/time.ts script/time/time.sh
rm -f /tmp/profile
nvim --cmd 'profile start /tmp/profile' --cmd 'profile file *' -u vimrc +q
