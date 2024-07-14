let s:path = '/tmp/vimyank'

function vimrc#feat#clipboard#load() abort
  call setreg(v:register, readfile(s:path)->join()->json_decode())
  echo 'restore register from clipboard'
endfunction

function vimrc#feat#clipboard#save() abort
  call writefile([json_encode(getreginfo())], s:path)
  echo 'save register to clipboard'
endfunction
