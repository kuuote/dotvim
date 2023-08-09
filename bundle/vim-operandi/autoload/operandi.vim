autocmd User operandi#open#* :

let s:types = {}

function! s:get_type(type) abort
  if !has_key(s:types, a:type)
    let l:type = operandi#type#{a:type}#load()
    let s:types[a:type] = l:type
    return l:type
  endif
  return s:types[a:type]
endfunction

function! s:execute() abort
  let l:cmd = getline('.')
  let l:Executor = b:operandi_executor
  " TODO: openerに準じた閉じ方をする
  tabclose

  call l:Executor(l:cmd)
endfunction

function! operandi#open(type, opts = {}) abort
  let l:type = s:get_type(a:type)

  " TODO: opener指定できるようにする
  -tabnew
  setlocal buftype=nofile bufhidden=hide noswapfile

  call setline(2, l:type.source())
  let b:operandi_executor = l:type.executor

  " TODO: ユーザーにマッピングさせる
  nnoremap <buffer> <nowait> <CR> <Esc><Cmd>call <SID>execute()<CR>
  inoremap <buffer> <nowait> <CR> <Esc><Cmd>call <SID>execute()<CR>

  execute 'doautocmd <nomodeline> User operandi#open#' .. a:type
endfunction

function! operandi#register(type, def) abort
  let s:types[a:type] = a:def
endfunction
