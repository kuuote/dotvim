function vimrc#denops#autoload(name) abort
  let plugin = 'vimrc_' .. a:name
  if !denops#plugin#is_loaded(plugin)
    call denops#plugin#register(plugin, printf('%s/denops/@vimrc/%s.ts', $DOTVIM, a:name))
  endif
endfunction

function vimrc#denops#request(name, method, params) abort
  let plugin = 'vimrc_' .. a:name
  call vimrc#denops#autoload(a:name)
  call denops#plugin#wait(plugin)
  return denops#request(plugin, a:method, a:params)
endfunction

function vimrc#denops#notify(name, method, params) abort
  let plugin = 'vimrc_' .. a:name
  call vimrc#denops#autoload(a:name)
  let method = a:method
  let params = a:params
  call denops#plugin#wait_async(plugin, {-> denops#notify(plugin, method, params) })
endfunction
