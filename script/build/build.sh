#!/bin/bash -u
cd $1 || exit 1
ls -1A --color=never | grep -v '^\.git$' | xargs rm -rf
git reset --hard @{u}
exec $2
