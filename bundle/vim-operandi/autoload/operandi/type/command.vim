augroup operandi#internal
  autocmd User operandi#open#command set syntax=vim
augroup END

function! s:source() abort
  return range(histnr(':'), 0, -1)->map('histget(":", v:val)')->filter('!empty(v:val)')
endfunction

function! s:executor(cmd, opts) abort
  let s:cmd = a:cmd
  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  let typed = get(a:opts, 'typed', v:true)
  call feedkeys(":\<CR>", typed ? 'nt' : 'n')
endfunction


function! operandi#type#command#load() abort
  return #{
  \   source: function('s:source'),
  \   executor: function('s:executor'),
  \ }
endfunction
