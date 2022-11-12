"
" '<,'>call vimrc#blocksort('^"', 'function.*')
function! vimrc#blocksort(finder, sorter) abort range
  call denops#request('vimrc', 'blockSort', [a:firstline, a:lastline, a:finder, a:sorter])
endfunction

" pathに指定したものをglobして:sourceする
function! vimrc#load_scripts(path) abort
  for f in sort(glob(a:path, v:true, v:true))
    if f =~# '.lua$'
      execute 'luafile' f
    else
      execute "source" f
    endif
  endfor
endfunction

"
function! vimrc#oresyntax(...) abort
  " ひらがな
  syntax match Green /[\u3042-\u3093]/
  " カタカナ
  syntax match Blue /[\u30a2-\u30fc]/
  " 漢字
  syntax match Red /[\u4e00-\u9fff]/
  syntax match ErrorMsg /[[\]]/
  syntax match Yellow /[[:alnum:]]/
endfunction

" 正規表現とマッチする行にランダムで飛ぶ
function! vimrc#shufflejump(re) abort
  let lines = getline(1, '$')->map('[v:key + 1, v:val]')->filter('v:val[1] =~# a:re')
  let selected = rand() % len(lines)
  call cursor(lines[selected][0], 1)
endfunction

" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/autoload/vimrc.vim
function vimrc#keep_cursor(cmd) abort
  let curwin_id = win_getid()
  let view = winsaveview()
  try
    execute a:cmd
  finally
    if win_getid() == curwin_id
      call winrestview(view)
    endif
  endtry
endfunction
