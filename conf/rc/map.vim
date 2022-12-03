" <Space> + j/k でPageDown/Up
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" Short hand to window prefix
nnoremap <Space>w <C-w>

" タブ関連
nnoremap th <Cmd>tabprevious<CR>
nnoremap tl <Cmd>tabnext<CR>
nnoremap tq <Cmd>tabclose<CR>
nnoremap tt <Cmd>tab split<CR>

" <C-l>にハイライト消去・ファイル変更適用効果を追加
" from https://github.com/takker99/dotfiles/blob/9ebeede1a43f7900c4c35e2d1af4c0468565bee9/nvim/userautoload/init/mapping.vim#L34-L35
nnoremap <C-l> :nohlsearch<CR>:checktime<CR><Esc><C-l>

" from https://github.com/aonemd/aaku/blob/0455967a9eae4abc7d66c6d2ce8059580d4b3cc5/vim/vimrc#L66
nnoremap ! :!

" from https://gist.github.com/tsukkee/1240267
onoremap ( t(

" sugoi undo
nnoremap U <C-r>

" thanks monaqa and tsuyoshicho
"" code input advanced in insert mode
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

tnoremap fj <C-\><C-N>

" scroll to center
inoremap <C-c> <Cmd>normal! zz<CR>

function s:insert_map()
  " 括弧とか打つのにShift押したくないでござる
  " genius maping by @KosukeMizuno
  " heavily modified by me

  " いくつかのマッピングはleximaに渡すためにこちらではやらない
  " see main.toml
  call hypermap#map(';a', '\')
  " call hypermap#map(';s', '(')
  call hypermap#map(';d', '=')
  " call hypermap#map(';f', ')')
  " call hypermap#map(';w', '{')
  call hypermap#map(';e', '+')
  " call hypermap#map(';r', '}')
  call hypermap#map(';x', '<')
  call hypermap#map(';c', '-')
  call hypermap#map(';v', '>')
  call hypermap#map(';q', '|')
  call hypermap#map(';z', '_')
  call hypermap#map(';;', ':')
  call hypermap#map(',q', '!')
  call hypermap#map(',w', '@')
  call hypermap#map(',e', '#')
  call hypermap#map(',r', '$')
  call hypermap#map(',a', '&')
  " call hypermap#map(',s', '"')
  call hypermap#map(',d', '*')
  call hypermap#map(',f', '%')
  call hypermap#map(',z', '~')
  " call hypermap#map(',x', "'")
  call hypermap#map(',c', "^")
  call hypermap#map(',v', "`")
endfunction

" 遅いし必要ないので遅延
autocmd CmdlineEnter,InsertEnter * ++once call s:insert_map()
