function s:open(curwin) abort
  " in before VimEnter, do lazy evaluation
  " because gin.vim is using denops.vim
  if !denops#plugin#is_loaded('gin')
    execute 'autocmd User DenopsPluginPost:gin ++nested call s:open(' .. a:curwin .. ')'
    return
  endif

  " git root by gin
  let root = gin#util#worktree()

  " open window
  if a:curwin
    only
  else
    tab split
  endif

  " cd to git root
  execute 'tcd' root
  " open status window
  GinStatus
  " remove previous handler
  augroup gin-preview
    autocmd! * <buffer>
  augroup END
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
  if line =~# '^??'
    call win_execute(t:gin_preview.index, 'enew | diffthis')
  else
    call win_execute(t:gin_preview.index, 'GinEdit ' .. file .. ' | diffthis')
  endif
  call win_execute(t:gin_preview.worktree, 'set wrap')
  call win_execute(t:gin_preview.index, 'set wrap')
endfunction

command! -bang GinPreview call s:open(<bang>0)
