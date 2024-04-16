function vimrc#git#find_root(path = expand('%:p') ?? getcwd()) abort
  let path = a:path
  while v:true
    let git = path .. '/.git'
    let type = getftype(git)
    if type != ''
      return git->substitute('/*\.git$', '', '')
    endif

    let newpath = path->substitute('[^/]*/\?$', '', '')
    if path == newpath
      throw 'not git'
    endif
    let path = newpath
  endwhile
endfunction

function vimrc#git#find_worktree(path = expand('%:p') ?? getcwd()) abort
  let path = vimrc#git#find_root(a:path)
  let git = path .. '/.git'
  if getftype(git) == 'file'
    " TODO
  endif
  return #{worktree: path, root: path}
endfunction
