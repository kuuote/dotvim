#!/bin/bash -eux

yarn --frozen-lockfile
yarn run build
rm -rf node_modules
