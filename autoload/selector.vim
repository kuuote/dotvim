augroup vimrc-selector
  autocmd!
  autocmd User SelectorChanged :
augroup END

function! selector#changed() abort
  if expand('<afile>') !=# '@'
    return
  endif
  let oldline = get(b:, 'oldline', "\<Nul>")
  let newline = getcmdline()
  if oldline ==# newline
    return
  endif
  let b:oldline = newline
  let filtered = b:filter(b:source, getcmdline())
  call deletebufline('%', 1, '$')
  call setbufline('%', 1, filtered)
  call cursor(1, 1)
  doautocmd <nomodeline> User SelectorChanged
  redraw
endfunction

function! s:down() abort
  let current = line('.')
  if current == line('$')
    let next = 1
  else
    let next = current + 1
  endif
  call cursor(next, 1)
  redraw
  doautocmd <nomodeline> User SelectorChanged
  return ''
endfunction

function! s:up() abort
  let current = line('.')
  if current == 1
    let next = line('$')
  else
    let next = current - 1
  endif
  call cursor(next, 1)
  redraw
  doautocmd <nomodeline> User SelectorChanged
  return ''
endfunction

function! selector#run(source, ...) abort
  botright 1new
  let winid = winnr()
  let b:filter = function(printf('selector#filter#%s#filter', get(a:000, 0, 'denops')))
  let b:source = copy(a:source)
  execute 'resize' &cmdwinheight
  setlocal buftype=nofile bufhidden=hide noswapfile cursorline
  autocmd CmdlineEnter,CmdlineChanged <buffer> call selector#changed()
  cnoremap <buffer> <Esc> <C-c>
  " vim
  cnoremap <silent> <buffer> <C-j> <C-r>=<SID>down()<CR>
  cnoremap <silent> <buffer> <C-k> <C-r>=<SID>up()<CR>
  " emacs
  cnoremap <silent> <buffer> <C-n> <C-r>=<SID>down()<CR>
  cnoremap <silent> <buffer> <C-p> <C-r>=<SID>up()<CR>
  " cursor
  cnoremap <silent> <buffer> <Down> <C-r>=<SID>down()<CR>
  cnoremap <silent> <buffer> <Up> <C-r>=<SID>up()<CR>
  try
    let result = input('> ')
    return getline('.')
  catch
  finally
    close
  endtry
endfunction