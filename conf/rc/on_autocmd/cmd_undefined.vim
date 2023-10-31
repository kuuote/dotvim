" :KeepCursor {excmd}
" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1402-L1402
command! -nargs=+ KeepCursor call vimrc#keep_cursor(<q-args>)

" Show 'runtimepath'.
" from https://github.com/thinca/config/blob/74009e9e9d4a66bae820c592343351bc7d0ee4b8/dotfiles/dot.vim/vimrc#L1395-L1395
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

" from defaults.vim
command! DiffOrig tab split | vert new | set buftype=nofile | read ++edit # | 0d_
\ | diffthis | wincmd p | diffthis

" VIMEやるためのウィンドウを作る
""スクラッチバッファ作ってInsertLeaveと同時にclipboardに押し込む
function s:open_ime_window() abort
  let buf = getline(1, '$')
  tabnew
  setlocal buftype=nofile bufhidden=wipe noswapfile
  autocmd InsertLeave <buffer> let @+ = getline(1, '$')->join("\n")->trim()
  " 違うバッファに打ち込んでから開くことがあるので元のバッファを転写してコピーする
  call setline(1, buf)
  let @+ = getline(1, '$')->join("\n")->trim()
endfunction

command! IMEWindow call s:open_ime_window()

" 開いているファイルを削除
command! DeleteIt :!trash-put "%"

