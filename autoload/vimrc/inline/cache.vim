function vimrc#inline#cache#load(globpath, cachepath) abort
  call mkdir(fnamemodify(a:cachepath, ':h'), 'p')
  let inline = []
  let files = glob(a:globpath, 1, 1)
  call sort(files)
  for file in files
    let data = readfile(file)
    call extend(inline, data)
  endfor
  call writefile(inline, a:cachepath)
  execute 'source' a:cachepath
endfunction
