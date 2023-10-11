function vimrc#inline#cache#load(globpath, cachepath) abort
  let luapath = a:cachepath->substitute('vim$', 'lua', '')
  call mkdir(fnamemodify(a:cachepath, ':h'), 'p')
  let inline_vim = []
  let inline_lua = []
  let files = glob(a:globpath, 1, 1)
  call sort(files)
  for file in files
    try
      let data = readfile(file)
    catch
      " skip unreadable file or directory
      continue
    endtry
    " 末尾がluaで終わるファイルを雑にLuaのスクリプト扱いする
    if file =~# 'lua$'
      call extend(inline_lua, data)
    else
      call extend(inline_vim, data)
    endif
  endfor
  if !empty(inline_lua)
    " NeovimではLuaファイルをsourceできる
    call add(inline_vim, [has('nvim') ? 'source' : 'luafile', luapath]->join(' '))
    call writefile(inline_lua, luapath)
  endif
  call writefile(inline_vim, a:cachepath)
  execute 'source' a:cachepath
endfunction
