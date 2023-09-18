#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

dest="${path}.fget"
spill="${path}.spill"

sudo rm -rf "${dest}"
(
  mkdir -p "${path}"
  cd "${path}"
  git init
)
git clone --progress --reference "${path}" --dissociate "${repo}" "${dest}" || exit 1
if [[ "${rev}" != "" ]]; then
  (
    cd "${dest}"
    git checkout "${rev}"
  )
fi
mv "${path}/.git" "${spill}" || exit 1
mv "${dest}/.git" "${path}/.git" || exit 1
rm -rf "${spill}"
rm -rf "${dest}"
