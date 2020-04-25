" Author: cohama
" Modified: kuuote
" License: NYSL
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "cohama"

" base
hi Normal          ctermfg=249  ctermbg=234  cterm=NONE      guifg=#9E9EB5 guibg=#121230 gui=NONE

" programming literals
hi Comment         ctermfg=22                                guifg=#5A5A75               gui=italic
hi Constant        ctermfg=104               cterm=bold      guifg=#6D86CF               gui=bold
hi String          ctermfg=174                               guifg=#B07558
hi Character       ctermfg=166                               guifg=#C9773C
hi Number          ctermfg=204                               guifg=#C25367
hi Boolean         ctermfg=204                               guifg=#C4475D
hi Float           ctermfg=204                               guifg=#C4475D

" programming statements
hi Identifier      ctermfg=215               cterm=NONE      guifg=#BFAB86               gui=NONE
hi Function        ctermfg=114               cterm=NONE      guifg=#78C49C               gui=NONE
hi Statement       ctermfg=219               cterm=NONE      guifg=#E0A4CE               gui=NONE
hi Conditional     ctermfg=217               cterm=NONE      guifg=#DFE3B3               gui=NONE
hi Repeat          ctermfg=217               cterm=NONE      guifg=#DFE3B3               gui=NONE
hi Label           ctermfg=158               cterm=NONE      guifg=#C1E3B3               gui=NONE
hi Operator        ctermfg=229               cterm=NONE      guifg=#EBEAB2               gui=NONE
hi Keyword         ctermfg=219               cterm=NONE      guifg=#E897CF               gui=NONE
hi Exception       ctermfg=217               cterm=NONE      guifg=#DFE3B3               gui=NONE

" programming pre-processes
hi PreProc         ctermfg=37                cterm=NONE      guifg=#61ABC2               gui=NONE
hi Include         ctermfg=37                                guifg=#61ABC2
hi Define          ctermfg=37                                guifg=#61ABC2
hi Macro           ctermfg=37                                guifg=#61ABC2
hi PreCondit       ctermfg=37                                guifg=#61ABC2

" programming types
hi Type            ctermfg=110               cterm=NONE      guifg=#9BBCCC               gui=NONE
hi StorageClass    ctermfg=110                               guifg=#9BBCCC
hi Structure       ctermfg=75                                guifg=#6392FF
hi Typedef         ctermfg=110                               guifg=#9BBCCC

" specials
hi Special         ctermfg=69                                guifg=#6F91F7
hi Delimiter       ctermfg=255                               guifg=#FAF9F7
hi SpecialComment  ctermfg=245               cterm=bold      guifg=#6767A8               gui=italic
hi Debug           ctermfg=219               cterm=bold      guifg=#C0C0C0
hi SpecialKey      ctermfg=61                cterm=NONE      guifg=#595996               gui=NONE

" vim views
hi Cursor          ctermfg=16   ctermbg=253                  guifg=#040410 guibg=#D1CCDE
hi CursorIM        ctermfg=16   ctermbg=124                  guifg=#040410 guibg=#A08ADB
hi CursorLine                   ctermbg=232  cterm=NONE                    guibg=#16163e gui=NONE
hi CursorColumn                 ctermbg=232  cterm=NONE                    guibg=#151538 gui=NONE
hi ColorColumn                  ctermbg=23                                 guibg=#183645
hi Conceal         ctermfg=240                               guifg=#80809C
hi LineNr          ctermfg=246  ctermbg=233                  guifg=#80809C guibg=#080820
hi CursorLineNr    ctermfg=227  ctermbg=233                  guifg=#E6E229 guibg=#13132A
hi FoldColumn      ctermfg=240  ctermbg=233                  guifg=#80809C guibg=#36364D
hi SignColumn                   ctermbg=234                  guifg=NONE    guibg=#121230
hi Folded          ctermfg=109  ctermbg=16                   guifg=#7F7FB5 guibg=#333342
hi Search          ctermfg=251  ctermbg=24   cterm=underline guifg=#DCDCF5 guibg=#2F919E gui=underline guisp=#888844
hi IncSearch       ctermfg=16   ctermbg=202                  guifg=#000000 guibg=#9C9C11 gui=underline guisp=#FF0000
hi NonText         ctermfg=239  ctermbg=235                  guifg=#393980 guibg=#0F0F29
hi StatusLine      ctermfg=255  ctermbg=238  cterm=bold      guifg=#0D0DB5 guibg=#DEDEFA gui=bold
hi StatusLineNC    ctermfg=239  ctermbg=233  cterm=NONE      guifg=#5D5DBA guibg=#1E1E45 gui=NONE
hi Todo            ctermfg=33   ctermbg=NONE cterm=bold      guifg=#9B9CB0 guibg=NONE    gui=bold
hi TabLine         ctermfg=245  ctermbg=237  cterm=NONE      guifg=#9B9CB0 guibg=#36364D gui=NONE
hi TabLineSel      ctermfg=255  ctermbg=233  cterm=bold      guifg=#DEDEFA guibg=#0F0F29 gui=bold
hi TabLineFill     ctermfg=245  ctermbg=245                  guifg=#9B9CB0 guibg=#9B9CB0
hi Title           ctermfg=227               cterm=bold      guifg=#C7C561               gui=bold

" diffs
hi DiffAdd                      ctermbg=17                   guifg=NONE    guibg=#133311
hi DiffChange      ctermfg=181  ctermbg=236                  guifg=NONE    guibg=#240D23
hi DiffDelete      ctermfg=162  ctermbg=53                   guifg=#521111 guibg=#331111
hi DiffText                     ctermbg=239  cterm=bold      guifg=NONE    guibg=#4C1354 gui=bold,underline guisp=#999999

" complete menus
hi Pmenu           ctermfg=NONE ctermbg=237  cterm=NONE      guifg=NONE    guibg=#36364D gui=NONE
hi PmenuSel        ctermfg=NONE ctermbg=19                   guifg=#FFFFFF guibg=#6B6B96 gui=bold
hi PmenuSbar                    ctermbg=239                                guibg=#444496
hi PmenuThumb      ctermbg=244                                             guibg=#5959C2

" errors
hi Error           ctermfg=219  ctermbg=88                   guifg=NONE    guibg=#0F0F29 gui=undercurl guisp=#E32935
hi ErrorMsg        ctermfg=199  ctermbg=16   cterm=bold      guifg=#E32935 guibg=NONE
hi SpellBad        ctermbg=52                                                            gui=undercurl guisp=#AB06CC
hi SpellCap        ctermbg=53                                                            gui=undercurl guisp=#765FC7
hi SpellLocal      ctermbg=53                                                            gui=undercurl guisp=#765FC7
hi SpellRare       ctermbg=53                                                            gui=undercurl guisp=#765FC7

" others
hi Directory       ctermfg=114               cterm=bold      guifg=#0DBA5F               gui=bold
hi Ignore          ctermfg=244  ctermbg=232                  guifg=#1A1A38 guibg=NONE
hi MatchParen      ctermfg=255  ctermbg=53   cterm=bold      guifg=NONE    guibg=#571C5E gui=bold
hi ModeMsg         ctermfg=229                               guifg=#235E1C               gui=italic
hi MoreMsg         ctermfg=229               cterm=NONE      guifg=#5B7573               gui=NONE
hi Question        ctermfg=110                               guifg=#3A3A85
hi Underlined      ctermfg=244               cterm=underline guifg=#D5D6EB               gui=underline guisp=#999999
hi VertSplit       ctermfg=244  ctermbg=232  cterm=bold      guifg=#2A2A75 guibg=#02021A gui=bold
hi Visual          ctermfg=255  ctermbg=33                   guifg=NONE    guibg=#2F2F52
hi VisualNOS       ctermfg=255  ctermbg=33                   guifg=NONE    guibg=#2F2F52
hi WarningMsg      ctermfg=231  ctermbg=238  cterm=bold      guifg=#969035 guibg=NONE
hi WildMenu        ctermfg=110  ctermbg=16                   guifg=#DEDEFA guibg=#5858A3 gui=bold

" plugin settings
hi IndentGuidesOdd ctermfg=238  ctermbg=235                  guifg=#444466 guibg=#151538
hi IndentGuidesEven ctermfg=238 ctermbg=233                  guifg=#444466 guibg=#0D0D24
hi diffAdded       ctermfg=40                cterm=bold      guifg=#34CF36 guibg=#133311 gui=bold
hi agitDiffAdd     ctermfg=40                cterm=bold      guifg=#34CF36 guibg=#133311 gui=bold
hi diffRemoved     ctermfg=204                               guifg=#A31D1D guibg=#331111
hi agitDiffRemove  ctermfg=204                               guifg=#A31D1D guibg=#331111

" vim: set colorcolumn=20,33,46,62,76,90 :
