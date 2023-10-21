let s:defdir = expand('<sfile>:p:h') .. '/def'

function! CSSelectCallback(item, idx)
  if a:item is v:null
    return
  endif
  let path = printf("%s/%s.vim", s:defdir, a:item)
  " load colorscheme def
  let g:colors_name = ""
  source `=path`

  " and persist
  redraw
  if confirm('Save changes?', "&Yes\n&No\n", 2) == 1
    call writefile(['source ' .. path], '/tmp/colors.vim')
  endif
endfunction

function s:run() abort
  let defs = map(filter(readdir(s:defdir), 'v:val =~ "vim$"'), 'fnamemodify(v:val, ":r")')
  call luaeval('vim.ui.select(_A, {}, vim.fn.CSSelectCallback)', defs)
endfunction

call s:run()
