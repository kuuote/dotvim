" emulates keycode replace like mappings
function vimrc#keycode#replace(keys) abort
  return substitute(a:keys, '<[^>]*>', '\=eval(''"\'' .. submatch(0) .. ''"'')', 'g')
endfunction

" feedkeys wrapper with replace keycodes
function vimrc#keycode#feedkeys(keys, mode = v:null) abort
  call feedkeys(vimrc#keycode#replace(a:keys), a:mode)
endfunction
