augroup operandi#internal
  autocmd User operandi#open#* :
augroup END

let s:types = {}

function! s:get_type(type) abort
  if !has_key(s:types, a:type)
    let l:type = operandi#type#{a:type}#load()
    let s:types[a:type] = l:type
    return l:type
  endif
  return s:types[a:type]
endfunction

function! operandi#execute(opts = {}) abort
  if !exists('b:operandi')
    return
  endif
  let l:operandi = b:operandi
  let l:cmd = getline('.')

  " TODO: openerに準じた閉じ方をする
  tabclose
  if !win_gotoid(l:operandi.winid)
    throw 'operandi: parent window is already closed'
  endif

  call l:operandi.executor(l:cmd, a:opts)
endfunction

function! operandi#open(type, opts = {}) abort
  let l:operandi = {}
  let l:operandi.winid = win_getid()

  " TODO: opener指定できるようにする
  tabnew
  setlocal buftype=nofile bufhidden=hide noswapfile

  let l:type = s:get_type(a:type)
  call setline(2, l:type.source())
  let l:operandi.executor = l:type.executor

  " TODO: ユーザーにマッピングさせる
  nnoremap <buffer> <nowait> <CR> <Cmd>call operandi#execute()<CR>
  inoremap <buffer> <nowait> <CR> <Esc><Cmd>call operandi#execute()<CR>

  let b:operandi = l:operandi
  execute 'doautocmd <nomodeline> User operandi#open#' .. a:type
endfunction

function! operandi#register(type, def) abort
  let s:types[a:type] = a:def
endfunction
