" pathに指定したものをglobして:sourceする
function! vimrc#load_scripts(path) abort
  for f in sort(glob(a:path, v:true, v:true))
    execute "source" f
  endfor
endfunction

" 正規表現とマッチする行にランダムで飛ぶ
function! vimrc#shufflejump(re) abort
  let lines = getline(1, '$')->map('[v:key + 1, v:val]')->filter('v:val[1] =~# a:re')
  let selected = rand() % len(lines)
  call cursor(lines[selected][0], 1)
endfunction
