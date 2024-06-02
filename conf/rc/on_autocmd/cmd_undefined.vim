" :KeepCursor {excmd}
" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1402-L1402
command! -nargs=+ KeepCursor call vimrc#keep_cursor(<q-args>)

" Show 'runtimepath'.
" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1395-L1395
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

" from defaults.vim
command! DiffOrig tab split | vert new | set buftype=nofile | read ++edit # | 0d_
\ | diffthis | wincmd p | diffthis

" 開いているファイルを削除
command! DeleteIt :!trash-put "%"

" tmuxでVim開いてるwindowにfocusするやつ
command! TmuxFocus call vimrc#denops#notify('tmux', 'focus', [])
