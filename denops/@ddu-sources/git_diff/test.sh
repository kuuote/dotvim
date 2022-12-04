#!/bin/bash -u

out=$(pwd)/test.diff
dir=$(mktemp -d)
(
  git init ${dir}
  cd ${dir}
  echo hoge > hoge
  echo foo > foo
  git add -A
  git commit -m hoge
  echo piyo > hoge
  mv foo b\ a\ r
  git diff --no-color --no-prefix --no-relative --no-renames > a.diff
  git add -A
  git diff --no-color --no-prefix --no-relative --no-renames HEAD > ${out}
)
rm -rf ${dir}
