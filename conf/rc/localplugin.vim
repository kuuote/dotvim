" シェルで export localplugin=vim するとカレントディレクトリをrtpに加えるようになる
if $localplugin ==# 'vim'
  let &rtp = printf('%s,%s', getcwd(), &rtp)
endif
