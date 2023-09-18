#!/bin/bash -u

path="$1"
repo="$2"
rev="$3"

dest="${path}.fget"
spill="${path}.spill"

sudo rm -rf "${dest}"
sudo rm -rf "${spill}"

mkdir -p "${path}"
cd "${path}"
git init
head=$(git rev-parse @)
cd -

git clone --progress --reference-if-able "${path}" --dissociate --no-checkout "${repo}" "${dest}" || exit 1
cd "${dest}"
if [[ "${rev}" != "" ]]; then
  git switch "${rev}"
fi
git reset "${head}" > /dev/null
cd -

mv "${path}/.git" "${spill}" || exit 1
mv "${dest}/.git" "${path}/.git" || exit 1
rm -rf "${spill}"
rm -rf "${dest}"
