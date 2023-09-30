let s:root = '/tmp/inline.vim/'

function vimrc#inline#load(globpath) abort
  let path = s:root .. sha256($VIMDIR .. a:globpath) .. '.vim'
  if getftype(path) ==# 'file'
    execute 'source' path
  else
    call vimrc#inline#cache#load(a:globpath, path)
  endif
endfunction
