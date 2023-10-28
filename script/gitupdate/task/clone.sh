#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

if [[ -e "${path}" ]]; then
  exit
fi

git clone --progress "${repo}" "${path}" || exit 1
if [[ "${rev}" != "" ]]; then
  cd "${path}"
  git switch "${rev}"
fi
