function vimrc#mru#uniq(list) abort
  let visit = {}
  let result = []
  for line in a:list
    if !has_key(visit, line)
      call add(result, line)
      let visit[line] = v:true
    endif
  endfor
  return result
endfunction

function vimrc#mru#save(file, opts = {}) abort
  if has_key(a:opts, 'data')
    let data = a:opts.data
  else
    try
      let data = readfile(a:file)
    catch
      let data = []
    endtry
  endif
  if has_key(a:opts, 'line')
    call insert(data, a:opts.line)
  endif
  call mkdir(data->fnamemodify(':h'), 'p')
  call writefile(vimrc#mru#uniq(data), a:file)
endfunction
