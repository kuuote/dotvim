" undoをpreviewするやつ
" 一括置換の結果を確認したりする際に便利だと思われる
" 発動したバッファでuを押すと元のバッファでundoが行われる
function vimrc#feat#undo#preview() abort
  try
    let view = winsaveview()
    normal! u
    let buf = getline(1, '$')
    execute "normal! \<C-r>"
  catch
    return
  finally
    call winrestview(view)
  endtry
  -tab split
  diffthis
  let filetype = &l:filetype
  vnew
  setlocal buftype=nofile bufhidden=delete noswapfile
  let &l:filetype = filetype
  call setline(1, buf)
  diffthis
  nnoremap <buffer> u <Cmd>tabclose<CR>u
endfunction
