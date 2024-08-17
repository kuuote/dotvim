#!/bin/bash -u

shopt -s globstar
if [[ -e deno.json ]]; then
  denojson=deno.json
else
  denojson=deno.jsonc
fi
deno run -A /data/vim/repos/github.com/Omochice/importmap-expand/cli.ts **/*.ts --option $denojson
