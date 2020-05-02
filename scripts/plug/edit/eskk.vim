call minpac#add('tyru/eskk.vim')

"use dotfiles dictionary
let g:eskk#dictionary = {'path':$HOME .. "/.vim/tmp/.skk-jisyo"}
let g:eskk#large_dictionary = {'path': '~/.skk/SKK-JISYO.L', 'sorted': 0, 'encoding': 'euc-jp'}
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
  exe a:mode .. 'noremap <buffer> <silent> ' .. a:seq .. ' :<C-u>call <SID>eskkfunc("' .. a:seq ..  '")<CR>'
endfunction

function! s:my_eskk_func()
  "オリジナルのSKK-i-searchモードみたいな感じで
  nmap <buffer> <silent> <Space>s :<C-u>set nohlsearch<CR>/jf
  nmap <buffer> <silent> <Space>r :<C-u>set nohlsearch<CR>?jf
  "よく使うモーションと同時にeskkを起動
  call s:eskkmap('n', 'A')
  call s:eskkmap('n', 'C')
  call s:eskkmap('n', 'I')
  call s:eskkmap('n', 'O')
  call s:eskkmap('n', 'a')
  call s:eskkmap('n', 'cG')
  call s:eskkmap('n', 'cc')
  call s:eskkmap('n', 'i')
  call s:eskkmap('n', 'o')
  call s:eskkmap('v', 'I')
  call s:eskkmap('v', 'c')
  "個人的によく使うやつ、wipeout
  nnoremap <buffer> <silent> w :<C-u>call <SID>eskkfunc('ggcG')<CR>
  "基本的にs使わないので押しづらいCの代わり
  nnoremap <buffer> <silent> s :<C-u>call <SID>eskkfunc('C')<CR>
endfunction

command! MyEskk :call <SID>my_eskk_func()
