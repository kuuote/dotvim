if !exists("g:lrc_{{_expr_:sha256(expand("%:p"))}}")
  let g:lrc_{{_expr_:sha256(expand("%:p"))}} = 1
  let s:this = expand("<sfile>")

  function! s:open() abort
    execute "buf" bufnr(s:this, v:true)
  endfunction

  nnoremap <silent> <Space>lr :<C-u>call <SID>open()<CR>
  "ここに再帰的に呼ばれてほしくないこと(ファイル開くとか)を書く


  if argc() == 0
    "何もファイル開いてない時


  endif
endif
"何度呼ばれても構わない(もしくは呼ばれてほしい)物はここに書く

{{_cursor_}}
