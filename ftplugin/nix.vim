if !exists('*s:gf')
  function! s:gf()
    let cfile = expand('<cfile>')
    if cfile[0] ==# '.'
      let cfile = simplify(expand('%:p:h') .. '/' .. cfile)
    endif
    if isdirectory(cfile)
      let cfile ..= '/default.nix'
    endif
    execute 'edit' cfile
  endfunction
endif

nnoremap <buffer> gf <Cmd>call <SID>gf()<CR>
