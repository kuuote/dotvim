#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

dest="${path}.fget"
spill="${path}.spill"

rm -rf "${dest}"
git clone --progress --reference-if-able "${path}" --dissociate "${repo}" "${dest}" || exit 1
if [[ "${rev}" != "" ]]; then
  (
    cd "${dest}"
    git checkout "${rev}"
  )
fi
mkdir -p "${path}/.git"
mv "${path}/.git" "${spill}" || exit 1
mv "${dest}/.git" "${path}/.git" || exit 1
rm -rf "${spill}"
rm -rf "${dest}"

# cleaning
cd "${path}" || exit 1
[[ -e .vimrc_hash ]] && exit
ls -1A --color=never | grep -v '^\.git$' | xargs rm -rf
git restore .
/data/vim/repos/github.com/WayneD/rsync/support/git-set-file-times
