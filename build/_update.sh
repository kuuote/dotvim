#!/bin/bash -eux

git clean -dffx
git checkout .

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})

for doc in $(ls -1 | grep '^\(doc\|README*\)$'); do
  git --no-pager diff -R $upstream $doc
done
git merge --ff-only
if [[ -e denops ]]; then
  deno --unstable cache --no-check denops/**/*.ts
fi
