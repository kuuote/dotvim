" headlessでdenops動かすのが困難なので裏でターミナル起こす
let s:id = -1

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
    call jobstop(s:id)
    let s:finish = v:false
    let s:id = jobstart('~/.vim/f'->expand(), #{
      \ env: #{
        \ VIM: '',
        \ VIMRUNTIME: '',
      \ },
      \ on_exit: {job, status -> [
        \ execute('echomsg "makestate end: " .. status', ''),
        \ execute('if status == 0 | let s:finish = v:true | endif', ''),
      \ ]},
      \ pty: v:true,
    \ })
  endfunction
else
  " Vimだとターミナルあると終了できないので待たなくてもいい
  function vimrc#dpp#makestate_job()
    silent! call job_stop(s:id, 'kill')
    let s:id = term_start('~/.vim/f'->expand(), #{
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
