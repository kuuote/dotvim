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

  call operandi#opener#{l:operandi.opener}#close()
  if !win_gotoid(l:operandi.winid)
    throw 'operandi: parent window is already closed'
  endif

  call l:operandi.executor(l:cmd, a:opts)
endfunction

let s:bufs = []

function! operandi#open(type, opts = {}) abort
  let l:operandi = {}
  let l:operandi.winid = win_getid()
  let l:operandi.opener = get(a:opts, 'opener', 'tab')

  call operandi#opener#{l:operandi.opener}#open()
  setlocal buftype=nofile bufhidden=hide noswapfile

  let to_remove = s:bufs->copy()->filter('empty(win_findbuf(v:val))')
  for b in to_remove
    silent! execute 'bwipeout!' b
  endfor
  eval s:bufs->filter('!empty(getbufinfo(v:val))')
  eval s:bufs->add(bufnr())

  let l:type = s:get_type(a:type)
  call setline(2, l:type.source())
  let l:operandi.executor = l:type.executor

  let b:operandi = l:operandi
  execute 'doautocmd <nomodeline> User operandi#open#' .. a:type
endfunction

function! operandi#register(type, def) abort
  let s:types[a:type] = a:def
endfunction
