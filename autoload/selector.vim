function selector#refresh(data) abort
  call deletebufline('%', 1, '$')
  call setbufline('%', 1, a:data)
  call cursor(1, 1)
  redraw
endfunction

function selector#changed() abort
  if expand('<afile>') !=# '@'
    return
  endif
  let oldline = get(b:, 'oldline')
  let newline = getcmdline()
  if oldline is# newline
    return
  endif
  let b:oldline = newline
  let filtered = b:filter(getcmdline())
  " TODO: 非同期対応
  call selector#refresh(filtered)
endfunction

function s:down() abort
  call cursor(line('.') + 1, 1)
  redraw
endfunction

function s:up() abort
  call cursor(line('.') - 1, 1)
  redraw
endfunction

function selector#run(source, filter_name = 'exact') abort
  -tabnew
  setlocal buftype=nofile bufhidden=wipe noswapfile cursorline
  call selector#filter#{a:filter_name}#gather(a:source)
  let b:filter = function(printf('selector#filter#%s#filter', a:filter_name))
  autocmd CmdlineEnter,CmdlineChanged <buffer> call selector#changed()
  cnoremap <buffer> <silent> <C-c> <Cmd>let b:cancel = v:true<CR><CR>
  cnoremap <buffer> <silent> <Esc> <Cmd>let b:cancel = v:true<CR><CR>
  " vim
  cnoremap <silent> <buffer> <C-j> <Cmd>call <SID>down()<CR>
  cnoremap <silent> <buffer> <C-k> <Cmd>call <SID>up()<CR>
  " emacs
  cnoremap <silent> <buffer> <C-n> <Cmd>call <SID>down()<CR>
  cnoremap <silent> <buffer> <C-p> <Cmd>call <SID>up()<CR>
  " cursor
  cnoremap <silent> <buffer> <Down> <Cmd>call <SID>down()<CR>
  cnoremap <silent> <buffer> <Up>   <Cmd>call <SID>up()<CR>
  try
    call input('> ')
    if get(b:, 'cancel', v:false)
      throw 'selector cancelled'
    endif
    return getline('.')
  finally
    tabclose
  endtry
endfunction
