function s:wait()
  while v:true
    let stat = vimrc#denops#request('makestate', 'status', [])
    if empty(stat)
      return
    endif
    echo 'waiting ' .. stat->join(', ')
    redraw
    sleep 10m
    call getchar(0)
  endwhile
endfunction

augroup vimrc_dpp_makestate
  autocmd VimLeavePre * call s:wait()
augroup END

function vimrc#dpp#makestate_job()
  call vimrc#denops#notify('makestate', 'run', [])
endfunction
