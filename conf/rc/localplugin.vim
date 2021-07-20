" シェルで export localplugin=on するとカレントディレクトリをrtpに加えるようになる
if $localplugin ==# 'on'
  let &rtp = printf('%s,%s', getcwd(), &rtp)
endif
