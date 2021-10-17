" `consult-line` port from Emacs package `consult`
" -> https://github.com/minad/consult

function! s:changed() abort
  try
    silent! call win_execute(s:winid, 'call matchdelete(s:matchid)')
    let [l, s] = matchlist(getline('.'), '\v(\d+)\|(.*)')[1:2]
    let s = tolower(s)
    let c = min(filter(map(split(tolower(getcmdline()), '\s\+'), 'stridx(s, v:val)'), 'v:val != -1')) + 1
    call win_execute(s:winid, printf('call cursor(%s, %s)', l, c))
    call win_execute(s:winid, 'normal! zz')
    call win_execute(s:winid, 'let s:matchid = matchaddpos("Search", [[l, c]])')
    redraw
  catch
  endtry
endfunction

function! s:lines() abort
  let s:winid = win_getid()
  let lines = getline(1, '$')
  call map(lines, "v:key + 1 .. '|' .. v:val")
  let line = line('.')
  if len(lines) > 1 && line > 1
    " consultのように現在の行を起点にする
    let previous = lines[:line - 2]
    let next = lines[line - 1:]
    let lines = next + previous
  endif
  augroup vimrc-lines
    autocmd!
    autocmd User SelectorChanged call s:changed()
  augroup END
  try
    call selector#run(lines, 'grep')
  finally
    autocmd! vimrc-lines
    silent! call win_execute(s:winid, 'call matchdelete(s:matchid)')
  endtry
  normal! zz
endfunction

nnoremap zl <Cmd>call <sid>lines()<cr>
