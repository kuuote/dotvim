function vimrc#git#clone(url, path) abort
  execute printf('!git clone %s %s', a:url, a:path)
endfunction

function vimrc#git#use(url) abort
  let path = '/data/vim/repos/' .. a:url->substitute('.*://', '', '')
  if !isdirectory(path)
    call vimrc#git#clone(a:url, path)
  endif
  let &runtimepath = path .. ',' .. &runtimepath
endfunction
