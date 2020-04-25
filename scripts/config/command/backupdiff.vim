function! s:showfile(buf, file)
  call deletebufline(a:buf, 1, "$")
  call setbufline(a:buf, 1, readfile(a:file))
  diffupdate
endfunction

function! s:bdiff() abort
  let pname = substitute(resolve(expand("%:p")), "/", "%", "g")
  let path = substitute(printf("%s/%s*", &backupdir, pname), "/\\+", "/", "g")
  let files = sort(map(glob(path, v:true, v:true), "[v:val, getftime(v:val)]"), {a, b -> b[1] - a[1]})

  tab split
  diffthis
  let ft = &l:ft
  botright vertical new
  setlocal buftype=nofile bufhidden=hide noswapfile
  let &l:ft = ft
  diffthis
  let db = bufnr("%")

  botright new
  setlocal buftype=nofile bufhidden=hide noswapfile
  execute "resize" &cmdwinheight
  let w:diffbuf = db
  let w:files = files
  call setbufline("%", 1, map(copy(files), "strftime('%Y-%m-%dT%T', v:val[1])"))
  call s:showfile(db, files[0][0])
  autocmd CursorMoved <buffer> call s:showfile(w:diffbuf, w:files[line(".") - 1][0])
  nnoremap <buffer> h 1<C-w><C-w>
  nnoremap <buffer> l 2<C-w><C-w>
endfunction

command! BackupDiff call s:bdiff()
