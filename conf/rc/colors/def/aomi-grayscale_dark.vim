function s:on_colorscheme() abort
  let s:white = "#e4ecf3"
  " Neovimでなぜか色が付いているので埋め
  execute 'hi Function guifg=' .. s:white
endfunction
autocmd persistent_colorscheme ColorScheme aomi-grayscale call s:on_colorscheme()

set background=dark
colorscheme aomi-grayscale
