#!/bin/bash -u

cd $(dirname $0) || exit 1
deno run -A f.ts
