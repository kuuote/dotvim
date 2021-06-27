function! vimrc#fzf#run(source, sink, ...) abort
  let options = a:0 == 1 ? a:1 : ""
  call fzf#run({'source': a:source, 'sink': a:sink, 'options': options, 'window': {'width': 0.9, 'height': 0.9}})
endfunction
