" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1402-L1402
" :KeepCursor {excmd}
command -nargs=+ KeepCursor call vimrc#keep_cursor(<q-args>)

" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1395-L1395
" Show 'runtimepath'.
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

command! DeleteIt :!trash-put %
