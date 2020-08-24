#!/bin/bash -e

# jqを適用してコミットするスクリプト

cd $(dirname $0)

rm -rf tmp
for s in *.json; do
  if jq -S . < ${s} > tmp; then
    mv tmp ${s}
    git add ${s}
  fi
done
git commit -m "feat: update snippets"
