let s:script = expand('<sfile>:p:h') .. '/ff.ts'

function! s:get_current_file_directory() abort
  let path = expand('%:p')
  if empty(path)
    return getcwd()
  endif
  if !isdirectory(path)
    let path = fnamemodify(path, ':h')
  endif
  return substitute(path, '/$', '', '')
endfunction

function! s:sink(result) abort
  let dir =  s:get_current_file_directory() .. '/' .. a:result
  execute "edit" dir
endfunction

function! vimrc#fzf#ff#run() abort
  call vimrc#fzf#run(printf('deno run --allow-read %s %s', s:script, s:get_current_file_directory()), function('s:sink'), '--reverse --exact --no-sort')
endfunction
