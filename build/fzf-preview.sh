#!/bin/bash -eux

yarn --frozen-lockfile
yarn run release-build:rpc
rm -rf node_modules
