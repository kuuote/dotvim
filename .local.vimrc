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

augroup new_vimrc
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> call delete('/tmp/inline.vim', 'rf')
  autocmd BufWritePost <buffer> call vimrc#denops#notify('makestate', 'run', [])
  autocmd VimLeavePre <buffer> call s:wait()
augroup END
