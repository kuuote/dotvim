function! vimrc#ui#filetype#deno#menu() abort
  return {
  \ 'test': ':tabedit term://deno test --watch --unstable -A'
  \ 'testthis': ':tabedit term://deno test --watch --unstable -A %'
  \ }
endfunction
