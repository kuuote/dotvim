" Treat buffers from stdin as scratch.
" from https://github.com/airblade/dotvim/blob/edad9fe8793b7c9266039b4cf85272a9b10cd9cb/vimrc#L202-L203
autocmd vimrc StdinReadPost * :set buftype=nofile

" 初回検索時のみwrapscanする
augroup vimrc
  autocmd CmdlineEnter,CmdwinEnter / set wrapscan
  " timer使っているのはCmdlineを抜けた直後に走る検索でwrapscanを有効にするため
  autocmd CmdlineLeave,CmdwinLeave / call timer_start(0, {->execute("set nowrapscan")}) 
augroup END

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
