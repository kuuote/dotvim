" 1 common
nnoremap ' :
nnoremap <Space>. <Cmd>edit $VIMDIR/vimrc<CR>
nnoremap <Space>d <Cmd>DduSelectorCall filer<CR>
nnoremap Q <Cmd>confirm qa<CR>

" based from https://github.com/habamax/.vim/blob/5ae879ffa91aa090efedc9f43b89c78cf748fb01/plugin/mappings.vim?plain=1#L152
" HLとPageDown/PageUpを共用する
function s:pagedown() abort
  let line = line('.')
  let topline = winsaveview().topline
  normal! L
  if line == line('.')
    " 末尾にいたらPageDown
    normal! ztL
  endif
  if line('.') == line('$')
    " 行末に来たらウィンドウの末尾と最下行を合わせる
    normal! z-
    if winsaveview().topline != topline
      " サクラエディタ風の挙動
      " 既に行末にいる場合以外は元の行末にカーソルを置く
      execute line
    else
    endif
  endif
  normal! 0
endfunction

function s:pageup() abort
  let line = line('.')
  let topline = winsaveview().topline
  normal! H
  if line == line('.')
    " 先頭にいたらPageUp
    normal! zbH
  endif
  let newtopline = winsaveview().topline
  if newtopline == 1 && topline != newtopline
    " 上と同じく
    execute line
  endif
  normal! 0
endfunction

nnoremap <Space>j <Cmd>call <SID>pagedown()<CR>
nnoremap <Space>k <Cmd>call <SID>pageup()<CR>

" shellのcd用ヘルパー
""/tmp/vim_shell_cdにカレントファイルのディレクトリパスを書き込んでVimを落とす
nnoremap <C-q> <Cmd>call writefile([expand('%:p:h')], '/tmp/vim_shell_cd')<CR><Cmd>confirm qa<CR>

" sugoi undo
nnoremap U <C-r>

" tab
nnoremap H <Cmd>tabprevious<CR>
nnoremap L <Cmd>tabnext<CR>
nnoremap tt <Cmd>tab split<CR>

" window movement
nnoremap <Space>w <C-w>
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

" yank operation
"" L<denops-vimrc-yank>
nnoremap <CR> <Cmd>call vimrc#denops#request('yank', 'yank', [getline(1, '$')])<CR>

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" スクロール位置をトップからのPageDown幅に合わせる
"" function! s:align() abort
""   let pos = getcurpos()[1:]
""   let view = winsaveview()
""   normal! gg
""   while v:true
""     let cl = line('.')
""     if line('w0') <= pos[0] && pos[0] <= line('w$')
""       call cursor(pos)
""       return
""     endif
""     execute "normal! \<PageDown>"
""     if cl == line('.')
""       call winrestview(view)
""       echomsg 'wtf?'
""     endif
""   endwhile
"" endfunction

"" HL PageDown対応版
function! s:align() abort
  let pos = getcurpos()[1:]
  let view = winsaveview()
  normal! gg
  while v:true
    let cl = line('.')
    if line('w0') <= pos[0] && pos[0] <= line('w$')
      call cursor(pos)
      return
    endif
    normal! Lzt
    if cl == line('.')
      call winrestview(view)
      echomsg 'wtf?'
    endif
  endwhile
endfunction

nnoremap <Space>a <Cmd>call <SID>align()<CR>

" 開く前の方向に戻っていく
nnoremap <expr> tq printf('<Cmd>tabclose <Bar> tabnext %d<CR>', max([1, tabpagenr() - 1]))

