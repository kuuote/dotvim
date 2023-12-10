function s:transparent() abort
  hi EndOfBuffer guibg=NONE
  hi NonText guibg=NONE
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE
endfunction
autocmd persistent_colorscheme ColorScheme * call s:transparent()
