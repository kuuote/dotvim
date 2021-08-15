" `consult-line` port from Emacs package `consult`
" -> https://github.com/minad/consult

function! s:changed() abort
  try
    let [l, s] = matchlist(getline('.'), '\v(\d+)\|(.*)')[1:2]
    let c = min(filter(map(split(getcmdline(), '\s\+'), 'stridx(s, v:val)'), 'v:val != -1')) + 1
    call win_execute(s:winid, printf('call cursor(%s, %s)', l, c))
    call win_execute(s:winid, 'normal! zz')
    redraw
  catch
  endtry
endfunction

function! s:lines() abort
  let s:winid = win_getid()
  let lines = getline(1, '$')
  call map(lines, "v:key + 1 .. '|' .. v:val")
  let previous = lines[:line('.') - 2]
  let next = lines[line('.') - 1:]
  let rotated = next + previous
  augroup vimrc-lines
    autocmd!
    autocmd User SelectorChanged call s:changed()
  augroup END
  try
    call selector#run(rotated, 'denops')
  finally
    autocmd! vimrc-lines
  endtry
endfunction

nnoremap zl <Cmd>call <sid>lines()<cr>
