autocmd User operandi#open#mycommand set syntax=vim

let s:history = expand('$DOTVIM/.cmdhist')

function s:set(...)
  let visit = {}
  let result = []
  for list in a:000
    for line in list
      if !has_key(visit, line)
        call add(result, line)
        let visit[line] = v:true
      endif
    endfor
  endfor
  return result
endfunction

function s:source() abort
  let vim = range(histnr(':'), 0, -1)->map('histget(":", v:val)')->filter('!empty(v:val)')
  try
    let file = readfile(s:history)->filter('!empty(v:val)')
  catch
    let file = []
  endtry
  return s:set(vim, file)
endfunction

function s:executor(cmd) abort
  let s:cmd = a:cmd
  if s:cmd !~# '^:'
    let source = s:source()
    call insert(source, a:cmd)
    call writefile(source, s:history)
  endif
  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  call feedkeys(":\<CR>", s:cmd =~# '^:' ? 'n' : 'nt')
endfunction


function! operandi#type#mycommand#load() abort
  return #{
  \   source: function('s:source'),
  \   executor: function('s:executor'),
  \ }
endfunction
