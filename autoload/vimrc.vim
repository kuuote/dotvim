" pathに指定したものをglobして:sourceする
function! vimrc#load_scripts(path) abort
  for f in sort(glob(a:path, v:true, v:true))
    execute "source" f
  endfor
endfunction
