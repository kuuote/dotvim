let s:history = '/data/vimshared/cmdhist'

function s:_source() abort
  let vim = range(histnr(':'), 0, -1)->map('histget(":", v:val)')
  try
    let file = readfile(s:history)
  catch
    let file = []
  endtry
  return flatten([vim, file])
endfunction
function s:source() abort
  return s:_source()->vimrc#mru#uniq()
endfunction

function s:executor(cmd, opts) abort
  let typed = get(a:opts, 'typed', v:true)

  let mru_opts = #{data: s:_source()}
  if typed
    let mru_opts.line = a:cmd
  endif
  call vimrc#mru#save(s:history, mru_opts)
  " 本体の履歴を統合して消す
  autocmd SafeState * ++once call histdel(':')

  let s:cmd = a:cmd
  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  call feedkeys(":\<CR>", typed ? 'nt' : 'n')
endfunction


function! operandi#type#mycommand#load() abort
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
  setfiletype vim
  inoremap <buffer> <expr> P <SID>expandpath()
  inoremap <buffer> E <Esc><Cmd>call operandi#execute({'typed': v:false})<CR>
  nnoremap <buffer> ;<Tab> <Cmd>call operandi#execute({'typed': v:false})<CR>
endfunction

augroup operandi#open#mycommand
  autocmd User operandi#open#mycommand ++nested call s:hook()
augroup END
