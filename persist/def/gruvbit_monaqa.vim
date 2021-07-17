" gruvbit colorscheme with @monaqa config
" https://github.com/monaqa/dotfiles/blob/424b0ab2d7623005f4b79544570b0f07a76e921a/.config/nvim/scripts/plugin.vim#L34-L67

set background=dark
colorscheme gruvbit

hi! FoldColumn guibg=#303030
hi! NonText guifg=#496da9
hi! CocHintFloat guibg=#444444 guifg=#45daef
hi! link CocRustChainingHint CocHintFloat
" Diff に関しては前のバージョン
" (https://github.com/habamax/vim-gruvbit/commit/a19259a1f02bbfff37d72eebef6b5d5d22f22248)
" のほうが好みだったので。
hi! DiffChange guifg=NONE guibg=#314a5c gui=NONE cterm=NONE
hi! DiffDelete guifg=#968772 guibg=#5c3728 gui=NONE cterm=NONE
hi! MatchParen guifg=#ebdbb2 guibg=#51547d gui=NONE cterm=NONE

hi! VertSplit  guifg=#c8c8c8 guibg=NONE    gui=NONE cterm=NONE
hi! Visual     guifg=NONE    guibg=#4d564e gui=NONE cterm=NONE
hi! VisualBlue guifg=NONE    guibg=#4d569e gui=NONE cterm=NONE
hi! Folded     guifg=#9e8f7a guibg=#535657 gui=NONE cterm=NONE

hi! CursorLine           guifg=NONE    guibg=#535657
hi! CursorColumn         guifg=NONE    guibg=#535657

hi! BufferCurrent        guifg=#ebdbb2 guibg=#444444 gui=bold
hi! BufferCurrentMod     guifg=#dc9656 guibg=#444444 gui=bold
hi! BufferCurrentSign    guifg=#e9593d guibg=#444444 gui=bold
hi! BufferCurrentTarget  guifg=red     guibg=#444444 gui=bold
hi! BufferInactive       guifg=#bbbbbb guibg=#777777
hi! BufferInactiveMod    guifg=#dc9656 guibg=#777777
hi! BufferInactiveSign   guifg=#444444 guibg=#777777
hi! BufferInactiveTarget guifg=red     guibg=#777777
hi! BufferVisible        guifg=#888888 guibg=#444444
hi! BufferVisibleMod     guifg=#dc9656 guibg=#444444
hi! BufferVisibleSign    guifg=#888888 guibg=#444444
hi! BufferVisibleTarget  guifg=red     guibg=#444444
hi! BufferTabpages       guifg=#e9593d guibg=#444444 gui=bold
hi! BufferTabpageFill    guifg=#888888 guibg=#c8c8c8
hi! TabLineFill          guibg=#c8c8c8

let g:gruvbit_transp_bg = 1
