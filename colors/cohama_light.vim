" Author: cohama
" Modified: kuuote
" License: NYSL
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "cohama_light"

" base
hi Normal          ctermfg=239  ctermbg=231                  guifg=#56569C guibg=#E4E4F2 gui=NONE

" programming literals
hi Comment         ctermfg=113                               guifg=#9D9DBF               gui=italic
hi Constant        ctermfg=105               cterm=bold      guifg=#236FD9               gui=bold
hi String          ctermfg=172                               guifg=#BD2B00
hi Character       ctermfg=166                               guifg=#BD6100
hi Number          ctermfg=204                               guifg=#E65A5A
hi Boolean         ctermfg=204                               guifg=#E65A5A
hi Float           ctermfg=204                               guifg=#E65A5A

" programming statements
hi Identifier      ctermfg=88                cterm=NONE      guifg=#8C5656               gui=NONE
hi Function        ctermfg=19                                guifg=#00A303
hi Statement       ctermfg=207               cterm=NONE      guifg=#F238F2               gui=NONE
hi Conditional     ctermfg=209                               guifg=#857500
hi Repeat          ctermfg=209                               guifg=#857500
hi Label           ctermfg=158                               guifg=#41BA9C
hi Operator        ctermfg=232                               guifg=#000000
hi Keyword         ctermfg=199                               guifg=#1010E8
hi Exception       ctermfg=217                               guifg=#857500

" programming pre-processes
hi PreProc         ctermfg=39                                guifg=#19939C
hi Include         ctermfg=39                                guifg=#19939C
hi Define          ctermfg=39                                guifg=#19939C
hi Macro           ctermfg=39                                guifg=#19939C
hi Typedef         ctermfg=39                                guifg=#19939C

" programming types
hi Type            ctermfg=57                cterm=NONE      guifg=#8510E6               gui=NONE
hi StorageClass    ctermfg=57                cterm=NONE      guifg=#03488C               gui=NONE
hi Structure       ctermfg=26                cterm=NONE      guifg=#8510E6               gui=NONE
hi Typedef         ctermfg=26                cterm=NONE      guifg=#8510E6               gui=NONE

" specials
hi Special         ctermfg=69                                guifg=#C90460
hi Delimiter       ctermfg=232                               guifg=#303030
hi SpecialComment  ctermfg=245               cterm=bold      guifg=#8686BF gui=italic
hi Debug           ctermfg=219               cterm=bold
hi SpecialKey      ctermfg=61                                guifg=#16167A

" vim views
hi Cursor          ctermfg=16   ctermbg=253                                guibg=#1D1D54
hi CursorIM        ctermfg=16   ctermbg=124                                guibg=#541D1D
hi CursorLine                   ctermbg=230  cterm=NONE                    guibg=#DCDCF2 gui=NONE
hi CursorColumn                 ctermbg=195                                guibg=#DCDCF2 gui=NONE
hi ColorColumn                  ctermbg=230                                guibg=#EACEF5
hi LineNr          ctermfg=244  ctermbg=255                  guifg=#606080 guibg=#D3D3E8
hi CursorLineNr    ctermfg=16   ctermbg=226  cterm=bold      guifg=#080820 guibg=#C0C0FF
hi FoldColumn      ctermfg=250  ctermbg=255                  guifg=#373747 guibg=#A0A0C4
hi SignColumn                   ctermbg=234                                guibg=#C2C2C2
hi Folded          ctermfg=109  ctermbg=255                  guifg=#4B87A6 guibg=#C8DCE6
hi Search                       ctermbg=225  cterm=underline guifg=#FFFFFF guibg=#1FC2A7 gui=underline
hi IncSearch       ctermfg=14   ctermbg=209  cterm=underline guifg=#000000 guibg=#9DD1AA gui=underline
hi NonText         ctermfg=251  ctermbg=231                  guifg=#B2B2F7 guibg=#EDEDF7
hi StatusLine      ctermfg=27   ctermbg=117  cterm=bold      guifg=#C3DBE8 guibg=#11528C gui=bold
hi StatusLineNC    ctermfg=242  ctermbg=252  cterm=NONE      guifg=#308EE3 guibg=#C3DBE8 gui=NONE
hi Todo            ctermfg=33   ctermbg=NONE cterm=bold      guifg=#7C7CF2 guibg=NONE    gui=bold
hi TabLine         ctermfg=238  ctermbg=248  cterm=NONE      guifg=#73679C guibg=#C8C5D4 gui=NONE
hi TabLineSel      ctermfg=232  ctermbg=231  cterm=bold      guifg=#522AD1 guibg=#D8D3E8 gui=bold
hi TabLineFill     ctermfg=245  ctermbg=245                  guifg=#88839C guibg=#88839C
hi Title           ctermfg=170               cterm=bold      guifg=#D44848               gui=bold

" diffs
hi DiffAdd                      ctermbg=17                   guifg=NONE    guibg=#C0FFDD
hi DiffChange      ctermfg=181  ctermbg=236                  guifg=NONE    guibg=#DED3E8
hi DiffDelete      ctermfg=162  ctermbg=53                   guifg=#FFBFBF guibg=#FFDDDD
hi DiffText                     ctermbg=239  cterm=bold      guifg=NONE    guibg=#F7F0F3 gui=bold,underline

" complete menus
hi Pmenu           ctermfg=NONE ctermbg=195                  guifg=#52A2BA guibg=#BCD8E0
hi PmenuSel        ctermfg=NONE ctermbg=51                   guifg=#096480 guibg=#91D0E3 gui=bold
hi PmenuSbar                    ctermbg=153                                guibg=#6DAABD
hi PmenuThumb      ctermbg=39                                              guibg=#096480

" errors
hi Error           ctermfg=88   ctermbg=225                  guifg=NONE    guibg=NONE    gui=undercurl guisp=#FF0000
hi ErrorMsg        ctermfg=196  ctermbg=225  cterm=bold      guifg=#C90815 guibg=NONE
hi SpellBad        ctermbg=225                               guifg=NONE    guibg=NONE    gui=undercurl guisp=#C71E78
hi SpellCap        ctermbg=200                               guifg=NONE    guibg=NONE    gui=undercurl guisp=#A86FED
hi SpellLocal      ctermbg=200                               guifg=NONE    guibg=NONE    gui=undercurl guisp=#A86FED
hi SpellRare       ctermbg=200                               guifg=NONE    guibg=NONE    gui=undercurl guisp=#A86FED

" others
hi Directory       ctermfg=70                cterm=bold      guifg=#109410               gui=bold
hi Ignore          ctermfg=244  ctermbg=232                  guifg=#5B5BA1
hi MatchParen      ctermfg=53   ctermbg=153  cterm=bold      guifg=#3b3b81 guibg=#C9F2EE gui=bold
hi ModeMsg         ctermfg=162                               guifg=#D4138D
hi Question        ctermfg=110                               guifg=#9E708D
hi Underlined      ctermfg=244               cterm=underline                             gui=underline
hi VertSplit       ctermfg=244  ctermbg=232  cterm=bold      guifg=#222270 guibg=#222270
hi Visual                       ctermbg=159                                guibg=#BBE0FF
hi VisualNOS       ctermfg=255  ctermbg=33
hi WarningMsg      ctermfg=231  ctermbg=238  cterm=bold      guifg=#0303F2
hi WildMenu        ctermfg=110  ctermbg=16                   guifg=#222270 guibg=#F9F9FF gui=bold

" plugin settings
hi IndentGuidesOdd ctermfg=248  ctermbg=231                  guifg=#9B9BC9 guibg=#E9E9F7
hi IndentGuidesEven ctermfg=248 ctermbg=255                  guifg=#9B9BC9 guibg=#DBDBE8
hi diffAdded       ctermfg=19                cterm=bold      guifg=#00A303 guibg=#D8E6D9 gui=bold
hi agitDiffAdd     ctermfg=19                cterm=bold      guifg=#00A303 guibg=#D8E6D9 gui=bold
hi diffRemoved     ctermfg=204                               guifg=#E69191 guibg=#F0E4E4
hi agitDiffRemove  ctermfg=204                               guifg=#E69191 guibg=#F0E4E4

" vim: set colorcolumn=20,33,46,62,76,90 :
