let s:ops = {"line":"V", "char":"v", "block":"\<C-v>"}
function! DoNoSpaceYank(wise) abort
  let from = getpos("'[")
  let to = getpos("']")
  let visualop = s:ops[a:wise]

  call inputsave()

  keepjumps call setpos(".", from)
  keepjumps call feedkeys(visualop, "nx")
  keepjumps call setpos(".", to)
  keepjumps call feedkeys("y", "nx")

  call inputrestore()

  let cmd = "let @%s = substitute(@%s, '[[:space:]]*$', '', '')"
  execute printf(cmd, '"', '"')
  execute printf(cmd, v:register, v:register)
endfunction

function! NoSpaceYank(op) abort
  set opfunc=DoNoSpaceYank
  call feedkeys(a:op, "ni")
endfunction

nnoremap gy :<C-u>call NoSpaceYank("g@")<CR>
xnoremap gy :<C-u>call NoSpaceYank("gvg@")<CR>
onoremap gy g@
