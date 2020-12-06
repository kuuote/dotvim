"常にコマンドウィンドウ使いたい
nnoremap ; q:i

" sを付けたら普通のコマンドライン
nnoremap s; :

" swap
" nnoremap : ; "eftでリマップするので無効化
nnoremap q; q:
xnoremap ; :

" incsearchを消す
nnoremap H :<C-u>nohlsearch<CR>

nnoremap <Space>s :<C-u>update<CR>
nnoremap <Space>q :<C-u>confirm qa<CR>
nnoremap qq :<C-u>confirm qa<CR>
xnoremap qq :<C-u>confirm qa<CR>

"vimrcへのショートカット

function! s:open_vimrc_callback(id, result)
  if a:result == 1
    e ~/.vim/vimrc
    lcd %:p:h
  elseif a:result == 2
    e ~/.vim/gvimrc
    lcd %:p:h
  elseif a:result == 3
    Fern ~/.vim -drawer -reveal=~/.vim/scripts/config
  elseif a:result == 4
    Fern ~/.vim -drawer -reveal=~/.vim/scripts/plug
  endif
endfunction

function! s:open_vimrc()
  if has("popupwin")
    call popup_menu(['vimrc', 'gvimrc', 'config(using fern)', 'plugins(using fern)'], #{
          \ callback: funcref("s:open_vimrc_callback"),
          \ filter: 'popup_filter_menu',
          \ })
  else
    edit $MYVIMRC
    lcd %:p:h
  endif
endfunction

nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>:lcd %:p:h<CR>
nnoremap <silent> <Space>. :<C-u>call <SID>open_vimrc()<CR>
nnoremap <Space><Space>. :<C-u>source $MYVIMRC<CR>

nnoremap <Space>CD :<C-u>cd %:p:h<CR>
nnoremap <Space>cd :<C-u>lcd %:p:h<CR>

" 単語境界検索
cnoremap <expr> / empty(getcmdline()) ? '\<' : '/'
cnoremap <expr> ? empty(getcmdline()) ? '\<' : '?'
