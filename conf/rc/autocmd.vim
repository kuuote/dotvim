" from https://github.com/monaqa/dotfiles/blob/2cd4d9d7a92e1b1d2878e939a4bad370f16cf49c/.config/nvim/lua/rc/autocmd.lua
autocmd vimrc StdinReadPost * :set nomodified

" 検索時だけhlsearchしてほしい
augroup vimrc
  autocmd CmdlineEnter /,\? setglobal hlsearch
  autocmd CmdlineLeave /,\? setglobal nohlsearch
augroup END

" auto quickfix opener
" from https://github.com/monaqa/dotfiles/blob/424b0ab2d7623005f4b79544570b0f07a76e921a/.config/nvim/scripts/autocmd.vim#L100-L104
augroup vimrc
  autocmd QuickfixCmdPost [^l]* cwin
  autocmd QuickfixCmdPost l* lwin
augroup END

" https://github.com/tsuyoshicho/vimrc-reading/blob/4037e59bdfaad9063c859e5fe724579623ef7836/.vimrc#L1640-L1640
" 自分が書いたのを忘れて人のvimrcから持ってきているやつ～
augroup vimrc
  autocmd FileType
    \ help nested if &l:buftype ==# 'help'
    \ |             nnoremap <buffer> <CR> <C-]>
    \ |             nnoremap <buffer> <BS> <C-T>
    \ |           endif
augroup END

" 挿入モードに入った時にカーソルをセンターに持ってくる
" from https://twitter.com/verylargeboar/status/1501892456538771463
" nnoremap o zzo
autocmd vimrc InsertEnter * normal! zz

