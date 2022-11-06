let s:defdir = expand('<sfile>:p:h') .. '/def'

function! persist#run() abort
  let defs = map(filter(readdir(s:defdir), 'v:val =~ "vim$"'), "v:val[:-5]")
  let ch = &cmdwinheight
  set cmdwinheight=99
  let result = selector#run(defs, 'fzf')
  let &cmdwinheight = ch
  let path = printf("%s/%s.vim", s:defdir, result)

  " load colorscheme def
  let g:colors_name = ""
  source `=path`

  " and persist
  redraw
  if confirm('Save changes?', "&Yes\n&No\n", 2) == 1
    call writefile(readfile(path), $HOME .. "/.vim/local/colors.vim")
  endif
endfunction

nnoremap cs <Cmd>call persist#run()<CR>
