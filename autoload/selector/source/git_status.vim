function! selector#source#git_status#run() abort
  let repo = finddir(".git", expand("%:p:h") .. ";")
  if !empty(repo)
    let repo = fnamemodify(repo, ":p")
    let root = fnamemodify(repo, ":h:h") " ディレクトリ名が展開された場合末尾に/が付く
    call s:status(root)
  else
    throw "Not a git repository."
  endif
endfunction

function! s:changed(_) abort
  let winid = win_getid()
  silent! only
  let line = getline('.')
  let mode = line[:2]
  let file = line[3:]
  if stridx(mode, 'M') != -1
    let args = gina#core#args#new(printf('patch --opener="topleft new" --oneside %s', file))
    call gina#command#patch#call([1,1], args, '')
    call win_gotoid(winid)
    execute 'resize' &cmdwinheight
  elseif stridx(mode, '?') != -1 || stridx(mode, 'A') != -1
    execute 'topleft new' file
    call win_gotoid(winid)
    execute 'resize' &cmdwinheight
  endif
  redraw
endfunction

function! s:status(root) abort
  silent! only
  enew!
  silent! execute "tcd" a:root
  let status = systemlist('git status -s')
  augroup vimrc_gitstatus
    autocmd!
    autocmd User SelectorChanged call timer_start(0, function('s:changed'))
  augroup END
  try
    let result = selector#run(status)
  catch
    return
  finally
    autocmd! vimrc_gitstatus
    windo wincmd =
  endtry
  let file = result[3:]
  let action = selector#run([
  \ 'patch',
  \ 'add',
  \ 'reset',
  \ ])
  if action ==# 'add'
    execute 'Gina add' file
    call s:status(a:root)
  elseif action ==# 'reset'
    execute 'Gina reset' file
    call s:status(a:root)
  endif
endfunction
