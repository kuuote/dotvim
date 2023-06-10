let s:config = {'uiParams':{'ff':{'highlights': {}}}}

" border idea by @eetann

let g:vimrc#ddu_highlights = ""

" percent => [x, y, width, height]
function! s:rect(percent) abort
  let l:mcolumns = 1.0 * &columns * a:percent
  let l:mlines = 1.0 * &lines * a:percent
  let l:width = float2nr(mcolumns)
  let l:height = float2nr(mlines)
  let l:x = float2nr((&columns - mcolumns) / 2)
  let l:y = float2nr((&lines - mlines) / 2)
  return [l:x, l:y, l:width, l:height]
endfunction

function! s:set_size() abort
  let [l:winCol, l:winRow, l:winWidth, l:winHeight] = s:rect(0.9)
  let s:config['uiParams']['ff']['winCol'] = winCol
  let s:config['uiParams']['ff']['winWidth'] = winWidth
  let s:config['uiParams']['ff']['winRow'] = winRow
  let s:config['uiParams']['ff']['winHeight'] = winHeight

  " fzf-previewやtelescopeみたいなpreviewの出し方をする
  let s:config['uiParams']['ff']['previewWidth'] = winWidth / 2
  let s:config['uiParams']['ff']['previewCol'] = 0
  let s:config['uiParams']['ff']['previewRow'] = 0
  let s:config['uiParams']['ff']['previewHeight'] = 0
endfunction

function s:colorscheme()
  if &background ==# 'light'
    hi DduEnd guibg=#e0e0ff guifg=#e0e0ff
    hi DduFloat guibg=#e0e0ff guifg=#6060ff
    hi DduBorder guibg=#f0f0ff guifg=#6060ff
    hi DduMatch ctermfg=205 ctermbg=225 guifg=#ff60c0 guibg=#ffd0ff cterm=NONE gui=NONE
    hi DduCursorLine ctermfg=205 ctermbg=225 guifg=#ff6060 guibg=#ffe8e8 cterm=NONE gui=NONE
    let g:vimrc#ddu_highlights = "DduFloat,CursorLine:DduCursorLine,EndOfBuffer:DduEnd,Search:DduMatch"
  else
    let g:vimrc#ddu_highlights = 'Normal,DduBorder:Normal,DduMatch:Search'
  endif
  let s:config['uiParams']['ff']['highlights']['floating'] = g:vimrc#ddu_highlights
endfunction

function! s:reset() abort
  if has('nvim')
    call s:set_size()
  else
    let s:config['uiParams']['ff']['previewWidth'] = &columns / 2
  endif
  call s:colorscheme()
  call ddu#custom#patch_global(s:config)
endfunction

function! s:config() abort
  call ddu#custom#load_config(expand('$DOTVIM/conf/plug/ddu.ts'))
  call s:reset()
endfunction

call s:reset()
autocmd ColorScheme,VimResized * call s:reset()
autocmd User DenopsPluginPost:ddu call s:config()

autocmd User DenopsReady call ddu#start(#{
      \     ui: 'ff',
      \     uiParams: #{
      \       ff: #{
      \         ignoreEmpty: v:true,
      \       },
      \     },
      \   })
