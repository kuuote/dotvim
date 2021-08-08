function! selector#changed() abort
  let filtered = reverse(b:filter(b:source, getcmdline()))
  call deletebufline('%', 1, '$')
  call setbufline('%', 1, filtered)
  call cursor(line('$'), 1)
  redraw
endfunction

function! selector#run(source, ...) abort
  botright 1new
  let b:filter = function(printf("selector#filter#%s#filter", get(a:000, 0, "denops")))
  let b:source = copy(a:source)
  execute 'resize' &cmdwinheight
  setlocal buftype=nofile bufhidden=hide noswapfile cursorline
  autocmd CmdlineEnter,CmdlineChanged <buffer> call selector#changed()
  cnoremap <buffer> <Esc> <C-c>
  cnoremap <buffer> <C-j> <Cmd>call cursor(line('.') + 1, 1)<CR><Cmd>redraw<CR>
  cnoremap <buffer> <C-k> <Cmd>call cursor(line('.') - 1, 1)<CR><Cmd>redraw<CR>
  try
    let result = input('> ')
    return getline('.')
  catch
  finally
    bwipeout
  endtry
endfunction
