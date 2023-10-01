" adhoc version of dpp#source
function tmp#source(plugin) abort
  for p in g:dpp#_plugins
    if p.name ==# a:plugin
      if !p.sourced
        let &runtimepath = p.path .. ',' .. &runtimepath
        if has_key(p, 'hook_source')
          call execute(p.hook_source->split('\n'), '')
        endif
        for f in glob(p.path .. '/plugin/**/*', 1, 1)
          execute 'source' f
        endfor
        call denops#plugin#discover()
      endif
      let p.sourced = v:true
      return
    endif
  endfor
endfunction
