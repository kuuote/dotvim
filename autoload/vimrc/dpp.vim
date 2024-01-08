" headlessでdenops動かすのが困難なので裏でターミナル起こす
if has('nvim')
  let s:finish = v:true

  function s:wait()
    if !s:finish
      echo 'wait makestate'
      redraw
      call wait(-1, 's:finish', 10)
    endif
  endfunction

  augroup vimrc_dpp_makestate
    autocmd VimLeavePre * call s:wait()
  augroup END

  function vimrc#dpp#makestate_job()
    let s:finish = v:false
    call jobstart('~/.vim/f'->expand(), #{
      \ env: #{
        \ VIM: '',
        \ VIMRUNTIME: '',
      \ },
      \ on_exit: {job, status -> [
        \ execute('echomsg "makestate end: " .. status', ''),
        \ execute('let s:finish = v:true', ''),
      \ ]},
      \ pty: v:true,
    \ })
  endfunction
else
  " Vimだとターミナルあると終了できないので待たなくてもいい
  function vimrc#dpp#makestate_job()
    call term_start('~/.vim/f'->expand(), #{
      \ env: #{
        \ VIM: '',
        \ VIMRUNTIME: '',
      \ },
      \ exit_cb: {job, status -> [
        \ execute('echomsg "makestate end: " .. status', ''),
      \ ]},
      \ hidden: v:true,
    \ })
  endfunction
endif
