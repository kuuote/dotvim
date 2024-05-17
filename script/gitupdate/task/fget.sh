#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

dest="${path}.fget"

rm -rf "${dest}"

(
  GIT_SSH_COMMAND="ssh -o BatchMode=yes" git clone --progress --reference-if-able "${path}" --dissociate "${repo}" "${dest}" || exit 1

  if [[ "${rev}" != "" ]]; then
    cd "${dest}"
    git switch "${rev}" || git reset --hard "${rev}" || exit 1
    cd -
  fi

  if [[ -e "${path}/.vimrc_hash" ]]; then
    rsync -a --delete-before "${dest}/.git/" "${path}/.git/"
  else
    cd "${dest}"
    /data/vim/repos/github.com/WayneD/rsync/support/git-set-file-times > /dev/null
    rsync -a --delete-before "${dest}/" "${path}/"
  fi
)

rm -rf "${dest}"
