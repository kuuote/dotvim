function s:colorscheme()
  let highlights = {}
  if &background ==# 'light'
    hi DduEnd guibg=#e0e0ff guifg=#e0e0ff
    hi DduFloat guibg=#e0e0ff guifg=#6060ff
    hi DduBorder guibg=#f0f0ff guifg=#6060ff
    hi DduMatch ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE
    hi DduCursorLine ctermfg=205 ctermbg=225 guifg=#ff6060 guibg=#ffe8e8 cterm=NONE gui=NONE
    let highlights.floating = "DduFloat,EndOfBuffer:DduEnd,Search:DduMatch"
    let highlights.floatingCursorLine = "DduCursorLine"
  else
    let highlights.floating = 'Normal,DduBorder:Normal,DduMatch:Search'
  endif
  call ddu#custom#patch_global({'uiParams': {'ff': {'highlights': highlights}}})
endfunction

autocmd ColorScheme * call s:colorscheme()
call ddu#custom#load_config(expand('$DOTVIM/conf/plug/ddu.ts'))
