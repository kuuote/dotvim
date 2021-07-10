" fz#run(source, [sink])
function! fz#run(source, ...) abort
  let s:source = a:source
  augroup fz
    autocmd!
    autocmd CmdlineEnter @ call feedkeys(&cedit, "n")
    autocmd CmdwinEnter @ ++nested call fz#enter()
  augroup END
  try
    let result = input("")
    return result
  finally
    autocmd! fz
  endtry
endfunction

function! fz#enter() abort
  redraw
  autocmd fz CmdlineChanged @ call fz#changed()
  call fz#changed()
  call input(">")
endfunction

function! fz#changed() abort
  let re = join(split(getcmdline(), '\zs'), '.*')
  let filtered = filter(copy(s:source), 'v:val =~? re')
  call deletebufline("%", 1, "$")
  call setbufline("%", 1, filtered)
  redraw
endfunction
