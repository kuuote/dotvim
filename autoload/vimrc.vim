"
" '<,'>call vimrc#blocksort('^"', 'function.*')
function! vimrc#blocksort(finder, sorter) abort range
  call denops#request('vimrc', 'blockSort', [a:firstline, a:lastline, a:finder, a:sorter])
endfunction

let s:cache_path = '/tmp/vimrc_inline/'

function! s:collect_files(path, ...) abort
  let inline = get(a:000, 0, v:true)
  let cache = s:cache_path .. sha256(a:path)
  if filereadable(cache)
    return readfile(cache)
  endif
  let files = sort(glob(a:path, v:true, v:true))
  call mkdir(s:cache_path, 'p')
  if inline
    let vim = []
    let lua = []
    for f in files
      if f =~# '.lua$'
        call extend(lua, readfile(f))
      elseif f =~# '.vim$'
        call extend(vim, readfile(f))
      endif
    endfor
    let files = []
    if !empty(vim)
      let vimfile = s:cache_path .. sha256(a:path) .. '.vim'
      call writefile(vim, vimfile)
      call add(files, vimfile)
    endif
    if !empty(lua)
      let luafile = s:cache_path .. sha256(a:path) .. '.lua'
      call writefile(lua, luafile)
      call add(files, luafile)
    endif
  endif
  call writefile(files, cache)
  return files
endfunction

" pathに指定したものをglobして:sourceする
if has('nvim')
  function! vimrc#load_scripts(path) abort
    for f in s:collect_files(a:path)
      execute "source" f
    endfor
  endfunction
else
  function! vimrc#load_scripts(path) abort
    for f in s:collect_files(a:path)
      if f =~# '.lua$'
        execute 'luafile' f
      else
        execute "source" f
      endif
    endfor
  endfunction
endif

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
