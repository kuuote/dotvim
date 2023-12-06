let s:count = 0

function vimrc#denops_loader#load(path, sync = v:false) abort
  let name = 'loader_' .. s:count
  let s:count += 1
  call denops#plugin#register(name, a:path)
  if a:sync
    call denops#plugin#wait(name)
  endif
  return name
endfunction
