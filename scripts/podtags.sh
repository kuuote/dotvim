#!/bin/bash -u

export LANG=C # sort順が言語に依存している

# PODのような形式のタグを探し出し、tagsの形式に変換する
rg --vimgrep --glob !tags --glob !scripts/podtags.sh 'X<.*>' | perl -pe 's|([^:]+).*?(X<([^>]*)>).*|\3	\1	/\2|' | sort > /tmp/tags
# 差分があったら書き込み
if ! diff /tmp/tags tags; then
  echo copy
  cp /tmp/tags tags
fi
