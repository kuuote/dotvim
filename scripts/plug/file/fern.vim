call minpac#add('lambdalisue/fern.vim')

nnoremap <Space>f :<C-u>Fern . -drawer -toggle -reveal=%<CR>

function s:ask_path()
  let path = input("Path:", expand("%:p:h"))
  exe printf("Fern %s -drawer -toggle -reveal=%%", path)
endfunction

nnoremap <Space>F :<C-u>call <SID>ask_path()<CR>

function! s:rc()
  noremap <buffer> <nowait> q <C-w>p
  nmap <buffer> <CR> <Plug>(fern-action-open)
  noremap <buffer> <RightMouse> <LeftRelease>
  nmap <buffer> <RightRelease> h
  nmap <buffer> <LeftRelease> l
  setlocal foldmethod=marker
endfunction

function s:close_fern()
  "コマンドラインウィンドウでこれ走ると厄介なことになる
  if &filetype ==# "fern" || !empty(getcmdwintype())
    return
  endif
  for b in tabpagebuflist()
    if getbufvar(b, "&filetype") ==# "fern"
      execute "bdelete " .. b
    endif
  endfor
endfunction

augroup vimrc
  autocmd FileType fern call s:rc()
  "WinEnterだとgetcmdwintype()が機能しない
  autocmd BufEnter * call s:close_fern()
augroup END
