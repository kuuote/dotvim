autocmd User operandi#open#mycommand set syntax=vim

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

function s:executor(cmd) abort
  let opts = #{data: s:_source()}
  if a:cmd !~# '^:'
    let opts.line = a:cmd
  endif
  call vimrc#mru#save(s:history, opts)
  " 本体の履歴を統合して消す
  autocmd SafeState * ++once call histdel(':')

  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  let s:cmd = a:cmd
  call feedkeys(":\<CR>", s:cmd =~# '^:' ? 'n' : 'nt')
endfunction


function! operandi#type#mycommand#load() abort
  return #{
  \   source: function('s:source'),
  \   executor: function('s:executor'),
  \ }
endfunction
