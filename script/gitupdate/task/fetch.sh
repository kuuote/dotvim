#!/bin/bash -u

path="$1"

cd "${path}" || exit 1
git fetch --progress --all --prune
