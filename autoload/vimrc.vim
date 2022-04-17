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

function vimrc#oresyntax(...) abort
  " ひらがな
  syntax match Green /[\u3042-\u3093]/
  " カタカナ
  syntax match Blue /[\u30a2-\u30fc]/
  " 漢字
  syntax match Red /[\u4e00-\u9fff]/
  syntax match ErrorMsg /[[\]]/
  syntax match Yellow /[[:alnum:]]/
endfunction
