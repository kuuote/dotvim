" <Space> + j/k でPageDown/Up
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" Short hand to window prefix
nnoremap <Space>w <C-w>

" タブ関連
nnoremap td <Cmd>tcd %:p:h<CR>
nnoremap H <Cmd>tabprevious<CR>
nnoremap L <Cmd>tabnext<CR>
nnoremap tq <Cmd>tabclose<CR>
nnoremap tn <Cmd>-tab split<CR><Cmd>tcd %:p:h<CR>
nnoremap ts <Cmd>-tab split<CR>
nnoremap tt <Cmd>tab split<CR>
nnoremap tT <Cmd>tab split<CR><Cmd>tcd %:p:h<CR>

" <C-l>にハイライト消去・ファイル変更適用効果を追加
" from https://github.com/takker99/dotfiles/blob/9ebeede1a43f7900c4c35e2d1af4c0468565bee9/nvim/userautoload/init/mapping.vim#L34-L35
nnoremap <C-l> :nohlsearch<CR>:checktime<CR><Esc><C-l>

" from https://github.com/aonemd/aaku/blob/0455967a9eae4abc7d66c6d2ce8059580d4b3cc5/vim/vimrc#L66
nnoremap ! :!

" from https://gist.github.com/tsukkee/1240267
onoremap ( t(

" sugoi undo
nnoremap U <C-r>

tnoremap fj <C-\><C-N>

function s:insert_map()
  " 括弧とか打つのにShift押したくないでござる
  " genius maping by @KosukeMizuno
  " heavily modified by me

  " いくつかのマッピングはleximaに渡すためにこちらではやらない
  " see main.toml
  call hypermap#map(',q', '|')
  call hypermap#map(',a', '\')
  call hypermap#map(',z', '_')
  call hypermap#map(',e', '+')
  call hypermap#map(',d', '=')

  " from shougo-s-github
  " Sticky shift in English keyboard.
  " Sticky key.
  inoremap <expr> ;  vimrc#sticky#func()
  cnoremap <expr> ;  vimrc#sticky#func()
  snoremap <expr> ;  vimrc#sticky#func()
  tnoremap <expr> ;  vimrc#sticky#func()

  " scroll to up with 1/4 margin
  inoremap H <Cmd>call winrestview(#{topline: line('.') - getwininfo(win_getid())[0].height / 4})<CR>
  " scroll to center
  inoremap M <Cmd>call winrestview(#{topline: line('.') - getwininfo(win_getid())[0].height / 2})<CR>

  " thanks monaqa and tsuyoshicho
  "" code input advanced in insert mode
  inoremap <C-v>u <C-r>=nr2char(0x)<Left>

  " escape from parentheses
  inoremap ER <Esc><Cmd>call search('}', 'cez')<CR>a
  inoremap EF <Esc><Cmd>call search(')', 'cez')<CR>a
  inoremap EB <Esc><Cmd>call search(']', 'cez')<CR>a
endfunction

" 遅いし必要ないので遅延
autocmd CmdlineEnter,InsertEnter * ++once call s:insert_map()

" undoをpreviewするやつ
nnoremap <Space>u <Cmd>call vimrc#feat#undo#preview()<CR>

" ;を末尾に突っ込むやつ
nnoremap ;; $a;<Esc>
