let s:defdir = expand('<sfile>:p:h') .. '/def'

let s:defs = map(filter(readdir(s:defdir), 'v:val =~ "vim$"'), "v:val[:-5]")

function! persist#run() abort
  let ch = &cmdwinheight
  set cmdwinheight=99
  let result = selector#run(s:defs, 'denops_fzf')
  let &cmdwinheight = ch
  let path = printf("%s/%s.vim", s:defdir, result)

  " load colorscheme def
  let g:colors_name = ""
  source `=path`

  " and persist
  call writefile(readfile(path), $HOME .. "/.vim/local/colors.vim")
endfunction

command! Persist call persist#run()
