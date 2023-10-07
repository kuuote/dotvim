" adhoc version of dpp#source
function tmp#source(plugin) abort
  if has_key(g:dpp#_plugins, a:plugin)
    let p = g:dpp#_plugins[a:plugin]
    if !p.sourced
      let p.sourced = v:true
      let &runtimepath = p.path .. ',' .. &runtimepath
      if has_key(p, 'hook_source')
        " NOTE: line continuation must be converted.
        " execute() does not support it.
        call execute(p.hook_source->substitute('\n\s*\\', '', 'g')->split('\n'), '')
      endif
      for f in glob(p.path .. '/plugin/**/*', 1, 1)
        if getftype(f) == 'file'
          execute 'source' f
        endif
      endfor
      call denops#plugin#discover()
    endif
    return
  endif
endfunction

function tmp#on_key(plugin, mode, keys)
  execute a:mode .. 'unmap' a:keys
  call tmp#source(a:plugin)
  call feedkeys(a:keys, 'it')
endfunction
