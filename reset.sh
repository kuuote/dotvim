#!/bin/bash -u

git update-ref -d refs/heads/$(git branch --show-current)
#git reset $(git commit-tree -m hoge $(git hash-object -t tree /dev/null))
git reset
git add -A
git commit -m hoge
