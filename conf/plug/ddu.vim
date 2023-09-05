let s:hlbg = v:false

function s:colorscheme()
  let highlights = {}
  if &background ==# 'light'
    if s:hlbg
      hi DduEnd guibg=#e0e0ff guifg=#e0e0ff
      hi DduFloat guibg=#e0e0ff guifg=#6060ff
    else
      hi DduEnd guifg=#e0e0ff
      hi DduFloat guifg=#6060ff
    endif
    hi DduBorder guibg=#f0f0ff guifg=#6060ff
    hi DduMatch ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE
    hi DduCursorLine ctermfg=205 ctermbg=225 guifg=#ff6060 guibg=#ffe8e8 cterm=NONE gui=NONE
    let highlights.floating = "DduFloat,EndOfBuffer:DduEnd"
    let highlights.floatingCursorLine = "DduCursorLine"
  else
    hi def link DduMatch Search
    let highlights.floating = 'Normal,DduBorder:Normal,DduMatch:Search'
  endif
  call ddu#custom#patch_global({'uiParams': {'ff': {'highlights': highlights}}})
endfunction

function! LoadDduConfig() abort
  call ddu#custom#load_config(expand('$DOTVIM/conf/plug/ddu/ddu.ts'))
  call ddu#custom#load_config(expand('$DOTVIM/conf/plug/ddu/ff.ts'))
  call ddu#custom#load_config(expand('$DOTVIM/conf/plug/ddu/selector.ts'))
endfunction

autocmd ColorScheme * call s:colorscheme()
call LoadDduConfig()
