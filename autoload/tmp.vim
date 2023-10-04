" adhoc version of dpp#source
function tmp#source(plugin) abort
  let g:dpp#_plugins = deepcopy(g:dpp#_plugins)
  for p in g:dpp#_plugins
    if p.name ==# a:plugin
      if !p.sourced
        let &runtimepath = p.path .. ',' .. &runtimepath
        if has_key(p, 'hook_source')
          call execute(p.hook_source->split('\n'), '')
        endif
        for f in glob(p.path .. '/plugin/**/*', 1, 1)
          if getftype(f) == 'file'
            execute 'source' f
          endif
        endfor
        call denops#plugin#discover()
      endif
      let p.sourced = v:true
      return
    endif
  endfor
endfunction

function tmp#on_key(plugin, mode, keys)
  execute a:mode .. 'unmap' a:keys
  call tmp#source(a:plugin)
  call feedkeys(a:keys, 'it')
endfunction
