if !dein#tap('eskk.vim') | finish | endif

"use dotfiles dictionary
let g:eskk#dictionary = {'path':$HOME .. "/.vim/tmp/.skk-jisyo"}
let g:eskk#large_dictionary = {'path': '~/.skk/SKK-JISYO.L', 'sorted': 1, 'encoding': 'euc-jp'}

" improve eskk enabler
" see https://thinca.hatenablog.com/entry/20120716/1342374586
inoremap <expr> <script> f getline('.')[col('.') - 2] ==# 'j' ? "\<BS>" .. eskk#enable() : 'f'

function! s:eskk_enable_post() abort
  lmap <buffer> l <Plug>(eskk:disable)
endfunction

"register alphabet table
function! s:eskk_initialize_pre()
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call eskk#register_mode_table('hira', t)
endfunction

augroup vimrc
  autocmd User eskk-enable-post call s:eskk_enable_post()
  autocmd User eskk-initialize-pre call s:eskk_initialize_pre()
augroup END
