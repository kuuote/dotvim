#!/bin/bash -eux

shopt -s globstar

#npm ci
deno cache **/*.ts || true
npm run build
rm -rf node_modules
