function s:dowrite()
  if confirm("Commit changes?", "&Yes\n&No", 2) == 1
    Gin commit -F /tmp/komitto
    let winid = t:winid
    tabclose
    call win_gotoid(winid)
  endif
endfunction

function p#gin#komitto() abort
  let winid = win_getid()
  tab split
  let t:winid = winid
  GinTcd

  GinDiff --cached
  botright vsplit
  GinLog --oneline

  topleft new /tmp/komitto
  resize 3
  augroup p.gin.komitto
    autocmd!
    autocmd BufWritePost <buffer> call s:dowrite()
  augroup END
endfunction 
