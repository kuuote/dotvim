augroup gin-preview
  autocmd User gin-preview:* :
augroup END

function s:open(curwin) abort
  " in before VimEnter, do lazy evaluation
  " because gin.vim is using denops.vim
  if !denops#plugin#is_loaded('gin')
    execute 'autocmd gin-preview User DenopsPluginPost:gin ++nested call s:open(' .. a:curwin .. ')'
    return
  endif

  " git root by gin
  let root = gin#util#worktree()

  " open window
  if a:curwin
    silent! only
  else
    tab split
  endif

  " cd to git root
  execute 'tcd' root
  " open status window
  GinStatus
  " remove previous handler
  autocmd! gin-preview * <buffer>
  let t:gin_preview = {'cursor': [-1, -1], 'status': win_getid()}
  " open worktree window
  belowright new
  diffthis
  let t:gin_preview.worktree = win_getid()
  " open index window
  vnew
  diffthis
  let t:gin_preview.index = win_getid()
  " resize status window
  call win_gotoid(t:gin_preview.status)
  execute 'resize' &lines / 3
  " define handler
  autocmd gin-preview CursorMoved <buffer> ++nested call s:moved()
  doautocmd <nomodeline> User gin-preview:open
endfunction

function! s:moved() abort
  if !exists('t:gin_preview')
    return
  endif
  let new_cursor = [line('.'), col('.')]
  if t:gin_preview.cursor == new_cursor
    return
  endif
  let t:gin_preview.cursor = new_cursor
  let line = getline('.')
  if line =~# '^##'
    return
  endif
  diffoff!
  let file = fnamemodify(line[3:], ':p')
  call win_execute(t:gin_preview.worktree, 'edit ' .. file .. ' | diffthis')
  call win_execute(t:gin_preview.worktree, 'doautocmd <nomodeline> User gin-preview:worktree')
  if line =~# '^??'
    call win_execute(t:gin_preview.index, 'call s:open_not_index(' .. string(file) ..')')
  else
    call win_execute(t:gin_preview.index, 'GinEdit ' .. file .. ' | diffthis')
  endif
  call win_execute(t:gin_preview.index, 'doautocmd <nomodeline> User gin-preview:index')
  call win_execute(t:gin_preview.worktree, 'set wrap')
  call win_execute(t:gin_preview.index, 'set wrap')
endfunction

command! -bang GinPreview call s:open(<bang>0)

function! s:open_not_index(file) abort
  let path = 'ginpreview://' .. a:file
  let b = bufnr(path)
  if b != -1
    execute 'buf' b
    diffthis
    return
  endif
  enew
  diffthis
  let b:gin_preview_file = a:file
  setlocal buftype=acwrite bufhidden=hide noswapfile
  autocmd gin-preview BufWriteCmd <buffer> call timer_start(0, function('s:write_not_index'))
  execute 'file' path
endfunction

function! s:write_not_index(...) abort
  let b = bufnr()
  let file = b:gin_preview_file
  let text = getline(1, '$')
  call system('git add -N ' .. file)
  execute 'GinEdit ' .. file .. ' | diffthis'
  call setline(1, text)
  write
  execute 'bdelete!' b
endfunction
