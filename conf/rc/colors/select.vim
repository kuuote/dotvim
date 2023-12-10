let s:defdir = expand('<sfile>:p:h') .. '/def'

function! CSSelectCallback(item, idx)
  if a:item is v:null
    return
  endif
  let path = printf("%s/%s.vim", s:defdir, a:item)
  " load colorscheme def
  let g:colors_name = ""
  augroup persistent_colorscheme
    autocmd!
  augroup END
  source `=path`

  " and persist
  redraw
  if confirm('Save changes?', "&Yes\n&No\n", 2) == 1
    call writefile(['source ' .. path], '/tmp/colors.vim')
    " カラースキーム動的読み込みしてるのでキャッシュ吹き飛ばす必要あり
    call delete('/tmp/inline.vim', 'rf')
  endif
endfunction

function s:run() abort
  let defs = readdir(s:defdir)->filter('v:val =~ "vim$"')->map('fnamemodify(v:val, ":r")')
  call luaeval('vim.ui.select(_A, {}, vim.fn.CSSelectCallback)', defs)
endfunction

call s:run()
