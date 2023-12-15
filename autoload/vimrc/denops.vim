function vimrc#denops#autoload(name) abort
  let plugin = 'vimrc_' .. a:name
  if !denops#plugin#is_loaded(plugin)
    let files = globpath(&runtimepath, 'denops/@vimrc/' .. a:name .. '.ts', 1, 1)
    if empty(files)
      throw "can't find plugin: " .. a:name
    endif
    call denops#plugin#register(plugin, files[0])
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
