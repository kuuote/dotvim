function vimrc#git#use(url) abort
  let path = '/data/vim/repos/' .. a:url->substitute('.*://', '', '')
  if !isdirectory(path)
    execute printf('!git clone %s %s', a:url, path)
  endif
  let &runtimepath = path .. ',' .. &runtimepath
endfunction
