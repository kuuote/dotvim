function! vimrc#denops#reload(plugin) abort
  augroup vimrc.denops_reload
    autocmd!
    execute printf('autocmd User DenopsPluginPost:%s ++once echo "%s reloaded"', a:plugin, a:plugin)
  augroup END
  call denops#plugin#reload(a:plugin)
endfunction
