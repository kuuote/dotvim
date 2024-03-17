" 1 common
nnoremap ' :
nnoremap <Space>. <Cmd>edit $VIMDIR/vimrc<CR>
nnoremap <Space>d <Cmd>DduSelectorCall filer<CR>
nnoremap Q <Cmd>confirm qa<CR>

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

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" 開く前の方向に戻っていく
nnoremap <expr> tq printf('<Cmd>tabclose <Bar> tabnext %d<CR>', max([1, tabpagenr() - 1]))

" based from https://github.com/habamax/.vim/blob/5ae879ffa91aa090efedc9f43b89c78cf748fb01/plugin/mappings.vim?plain=1#L152
" HLとPageDown/PageUpを共用する
function s:pagedown() abort
  let line = line('.')
  normal! L
  if line == line('.')
    normal! ztL
  endif
  if line('.') == line('$')
    normal! z-
  endif
  normal! 0
endfunction

function s:pageup() abort
  let line = line('.')
  normal! H
  if line == line('.')
    normal! zbH
  endif
  normal! 0
endfunction

nnoremap <Space>j <Cmd>call <SID>pagedown()<CR>
nnoremap <Space>k <Cmd>call <SID>pageup()<CR>
