function! vimrc#ui#filetype#json#menu() abort
  return {
  \ 'jq': ':%!jq -S .'
  \ }
endfunction
