" undoをpreviewするやつ
" 一括置換の結果を確認したりする際に便利だと思われる
" 発動したバッファでuを押すと元のバッファでundoが行われる
function vimrc#feat#undo#preview() abort
  let u = undotree()
  let v = winsaveview()
  try
    silent! undo
    if undotree().seq_cur == u.seq_cur
      return
    endif
    let buf = getline(1, '$')
  catch
    return
  finally
    silent! execute 'undo' u.seq_cur
    call winrestview(v)
  endtry
  -tab split
  diffthis
  setlocal wrap
  let filetype = &l:filetype
  vnew
  setlocal buftype=nofile bufhidden=delete noswapfile
  let &l:filetype = filetype
  call setline(1, buf)
  diffthis
  setlocal wrap
  nnoremap <buffer> u <Cmd>tabclose<CR>u
endfunction
