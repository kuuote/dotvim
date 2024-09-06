source $MYVIMDIR/conf/rc/colors/def/common/transparent.vim

function s:setup() abort
  let palette = edge#get_palette('default', 0, {})
  execute printf('hi DiffAdd guifg=%s guibg=NONE', palette.green[0])
  execute printf('hi DiffChange guifg=%s guibg=NONE', palette.blue[0])
  execute printf('hi DiffDelete guifg=%s guibg=NONE', palette.red[0])
endfunction
autocmd persistent_colorscheme ColorScheme edge call s:setup()

source $MYVIMDIR/conf/rc/colors/def/edge_dark.vim
