"xterm互換端末以外は使わないという強い意志
if !has("nvim")
  set term=xterm-256color
endif
"ターミナルでもGUIと同じカラースキームを使う
set termguicolors

" set transparent
nnoremap <Space>tp :<C-u>hi Normal ctermbg=NONE guibg=NONE<CR>:hi NonText ctermbg=NONE guibg=NONE<CR>

" persistent colorscheme selector {{{

let s:this = expand("<sfile>")

" Derived from fzf.vim and vim-clap
function! s:colors() abort
  let colors = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
  if has('packages')
    let colors += split(globpath(&packpath, 'pack/*/opt/*/colors/*.vim'), "\n")
  endif
  return sort(map(colors, "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"))
endfunction

"save setting to the file
function! s:save() abort
  call vimrc#selector#close()
  let f = []
  call add(f, "let g:colors_name = " .. string(s:cs))
  call add(f, "set background=" .. s:bg)
  let tmpdir = $HOME .. "/.vim/tmp"
  call mkdir(tmpdir, "p")
  call writefile(f, tmpdir .. "/colors.vim")
  echo "Saved colorscheme setting"
endfunction

function! s:set(bg) abort
  let s:cs = getline(".")
  let s:bg = a:bg
  execute "colorscheme" s:cs
  let &bg = a:bg
  redraw!
endfunction

function! s:openbuf() abort
  let s:cs = get(g:, "colors_name", "default")
  let s:bg = &bg
  call vimrc#selector#openbuf(funcref("s:colors"))
  nnoremap <buffer> <nowait> d :<C-u>call <SID>set("dark")<CR>
  nnoremap <buffer> <nowait> l :<C-u>call <SID>set("light")<CR>
  nnoremap <buffer> <nowait> <silent> q :<C-u>call <SID>save()<CR>
endfunction

nnoremap <silent> cs :<C-u>call <SID>openbuf()<CR>

autocmd VimEnter * source ~/.vim/tmp/colors.vim
autocmd VimEnter * silent! call lightline#highlight()

" }}}

" vim: set fdm=marker:
