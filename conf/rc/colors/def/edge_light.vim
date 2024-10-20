function s:on_color_scheme() abort
  hi Pmenu guibg=#e0e0ff guifg=#6060ff
  hi PmenuSel guifg=#ff6060 guibg=#ffe8e8
  hi NormalFloat guibg=#e0e0ff guifg=#6060ff
  hi CmpItemAbbr guifg=#6060ff
  hi CmpItemKindText guifg=#6060ff
  hi PumHighlight ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE

  hi diffAdded guibg=#e0ffe0 guifg=#608060
  hi diffNewFile guibg=#e0ffe0 guifg=#608060

  hi diffRemoved guifg=#ff6060 guibg=#ffe8e8
  hi diffOldFile guifg=#ff6060 guibg=#ffe8e8

  " こっちで勝手に追加したやつ
  " see $MYVIMDIR/after/syntax/diff.vim
  hi diffIndicator guibg=#e0e0ff

  if has('nvim')
    hi @text.diff.indicator guibg=#e0e0ff
    hi @text.diff.add guibg=#e0ffe0 guifg=#608060
    hi link @text.diff.addsign @text.diff.add
    hi @text.diff.addindicator guibg=#e0e0ff guifg=#40b040
    hi link @text.diff.delete PmenuSel
    hi link @text.diff.delsign PmenuSel
    hi @text.diff.delindicator guibg=#e0e0ff guifg=#ff6060
  endif

  let s:palette = edge#get_palette('light', 0, {})
  "execute 'hi FuzzyMotionChar guifg=' .. s:palette.purple[0]
  execute 'hi FuzzyMotionSubChar guifg=' .. s:palette.green[0]
  execute 'hi FuzzyMotionMatch guibg=' .. s:palette.diff_green[0]
  execute 'hi FuzzyMotionShade guifg=' .. s:palette.grey_dim[0]
endfunction

autocmd persistent_colorscheme ColorScheme edge call s:on_color_scheme()

set background=light
let g:edge_disable_italic_comment = 1
colorscheme edge
