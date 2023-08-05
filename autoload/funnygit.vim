function s:dowrite()
  if confirm("Commit changes?", "&Yes\n&No", 2) == 1
    Gin commit -F /tmp/funnygit
    tabclose
  endif
endfunction

function funnygit#commit() abort
  execute '-tab split'
  GinTcd

  GinDiff --cached
  botright vsplit
  GinLog --oneline

  topleft new /tmp/funnygit
  resize 3
  augroup funnygit
    autocmd!
    autocmd BufWritePost <buffer> call s:dowrite()
  augroup END
endfunction
