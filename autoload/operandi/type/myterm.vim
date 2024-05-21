let s:history = '/data/vimshared/termhist'

function s:source() abort
  try
    return readfile(s:history)->vimrc#mru#uniq()
  catch
    return []
  endtry
endfunction

function s:executor(cmd, opts) abort
  call vimrc#mru#save(s:history, #{line: a:cmd})
  let cmd = a:cmd->substitute('%%', expand('%:p'), 'g')
  call vimrc#feat#terminal#open(cmd)
endfunction


function! operandi#type#myterm#load() abort
  return #{
  \   source: function('s:source'),
  \   executor: function('s:executor'),
  \ }
endfunction

function s:expandpath() abort
  let pos = mode() ==# 'c' ? getcmdpos() : col('.')
  let line = mode() ==# 'c' ? getcmdline() : getline('.')

  let left = line[pos - 2]

  if left ==# '/'
    return expand('#:p:t')
  else
    return expand('#:p:h') .. '/'
  endif
endfunction

function s:hook() abort
  inoremap <buffer> <expr> P <SID>expandpath()
  tcd #:p:h
endfunction

augroup operandi#open#myterm
  autocmd User operandi#open#myterm ++nested call s:hook()
augroup END
