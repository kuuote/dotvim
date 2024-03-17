function s:dowrite()
  if confirm("Commit changes?", "&Yes\n&No", 2) == 1
    Gin commit -F /tmp/funnygit
    let winid = t:winid
    tabclose
    call win_gotoid(winid)
  endif
endfunction

" X<funny-git-commit>
function funnygit#commit() abort
  let winid = win_getid()
  tab split
  let t:winid = winid
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
