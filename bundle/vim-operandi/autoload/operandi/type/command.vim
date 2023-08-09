autocmd User operandi#open#command set syntax=vim

function! s:source() abort
  return range(histnr(':'), 0, -1)->map('histget(":", v:val)')->filter('!empty(v:val)')
endfunction

function! s:executor(cmd) abort
  let s:cmd = a:cmd
  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  call feedkeys(":\<CR>", s:cmd =~# '^:' ? 'n' : 'nt')
endfunction


function! operandi#type#command#load() abort
  return #{
  \   source: function('s:source'),
  \   executor: function('s:executor'),
  \ }
endfunction
