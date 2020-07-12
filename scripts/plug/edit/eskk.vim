call minpac#add('tyru/eskk.vim')

"use dotfiles dictionary
let g:eskk#dictionary = {'path':$HOME .. "/.vim/tmp/.skk-jisyo"}
let g:eskk#large_dictionary = {'path': '~/.skk/SKK-JISYO.L', 'sorted': 1, 'encoding': 'euc-jp'}
"enable eskk in 'jf'
imap jf <Plug>(eskk:enable)
cmap jf <Plug>(eskk:enable)

"skk-search shortcut
nmap <Space>/ :<C-u>set nohlsearch<CR>/jf
nmap <Space>? :<C-u>set nohlsearch<CR>?jf

"sticky key
augroup vimrc
  autocmd User eskk-enable-post lnoremap <buffer> <expr> : eskk#filter(eskk#util#key2char(eskk#get_mode() ==# "ascii" ? ":" : ";"))
augroup END

"register alphabet table

function! s:eskk_initialize_pre()
  let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
  call t.add_map('z ', '　')
  call eskk#register_mode_table('hira', t)
endfunction

augroup vimrc
  autocmd User eskk-initialize-pre call s:eskk_initialize_pre()
augroup END

function! s:eskkfunc(seq)
  call eskk#enable()
  call feedkeys(a:seq, 'n')
endfunction

function! s:eskkmap(mode, seq)
  execute a:mode .. 'noremap <buffer> <silent> ' .. a:seq .. ' :<C-u>call <SID>eskkfunc("' .. a:seq ..  '")<CR>'
endfunction

function! s:my_eskk_func()
  " 挿入モードでとりあえずeskkを有効化する
  autocmd InsertEnter <buffer> call eskk#enable()
  " 個人的によく使うやつ、wipeout
  nnoremap <buffer> <silent> w :<C-u>call <SID>eskkfunc('ggcG')<CR>

  " 入力を前方検索してそこから後方全削除し挿入モードに入る
  nnoremap <expr> <SID>hatena "?" .. input("") .. "<CR>:nohlsearch<CR>C"
  nnoremap <nowait> <script> s :<C-u>call eskk#enable()<CR><SID>hatena
  " 逆三角はあると便利
  nnoremap <nowait> S :<C-u>call eskk#enable()<CR>?▽<CR>:nohlsearch<CR>C
endfunction

command! MyEskk :call <SID>my_eskk_func()
