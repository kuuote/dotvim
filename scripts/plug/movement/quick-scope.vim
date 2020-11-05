finish
" ↑ vim-eft導入のため無効化
call minpac#add('unblevable/quick-scope')

let g:qs_lazy_highlight = 1

function! s:apply_highlight() abort
  " primary
  highlight QuickScopePrimary cterm=reverse gui=reverse

  " secondary
  " let hl = execute("hi Normal")
  " let m = match(hl, "guibg")
  " let guibg = map(split(hl[m+7 : m+13], '..\zs'), "str2nr(v:val, 16)")
  " for i in  range(len(guibg))
  "   let c = guibg[i]
  "   if &background ==# "dark"
  "     let c = 255-c
  "   endif
  "   let c = float2nr(c*0.75)
  "   if &background ==# "dark"
  "     let c = 255-c
  "   endif
  "   let guibg[i] = c
  " endfor
  " let guibgcode = join(map(guibg, "printf('%02x', v:val)"), "")
  " execute printf("hi QuickScopeSecondary guibg=#%s", guibgcode)
  highlight QuickScopeSecondary cterm=underline gui=underline
endfunction

augroup vimrc
  autocmd ColorScheme * call s:apply_highlight()
augroup END
call s:apply_highlight()
