#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

dest="${path}.fget"

rm -rf "${dest}"

(
  git clone --progress --reference-if-able "${path}" --dissociate "${repo}" "${dest}" || exit 1

  if [[ "${rev}" != "" ]]; then
    cd "${dest}"
    git switch "${rev}" || git reset --hard "${rev}" || exit 1
    cd -
  fi

  if [[ -e "${path}/.vimrc_hash" ]]; then
    rsync -a --delete-before "${dest}/.git/" "${path}/.git/"
  else
    rsync -a --delete-before "${dest}/" "${path}/"
  fi
)

rm -rf "${dest}"
