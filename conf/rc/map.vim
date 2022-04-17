" VimはUSキーボードに優しくないよね
nnoremap ; :
xnoremap ; :
nnoremap q; q:

" Prefixの開放
nnoremap ' <Nop>
nnoremap s <Nop>

" Window移動
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

" 設定開くマン
nnoremap <Space>. <Cmd>edit ~/.vim/conf<CR>

" Open directory for netrw like plugin
nnoremap <Space>d <Cmd>edit %:p:h<CR>

" <Space> + j/k でPageDown/Up
nnoremap <Space>j <PageDown>
nnoremap <Space>k <PageUp>

" 安全にかつ高速に終わるための設定
nnoremap Q <Cmd>confirm qa<CR>
xnoremap Q <Cmd>confirm qa<CR>
onoremap Q <Cmd>confirm qa<CR>

" こまめなセーブは忘れずに
nnoremap <Space>s <Cmd>update<CR>

" 背景を一瞬で透過する
nnoremap <Space>tp <Cmd>hi Normal guibg=NONE <Bar> hi EndOfBuffer guibg=NONE<CR>

" Short hand to window prefix
nnoremap <Space>w <C-w>

" タブ関連
nnoremap <Tab> <Cmd>tabnext<CR>
tnoremap <Tab> <Cmd>tabnext<CR>
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

" short hand to window-down/up
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" 括弧とか打つのにShift押したくないでござる
" genius maping by @KosukeMizuno
" heavily modified by me

" disabled some mappings because I'm using lexima.vim
" see main.toml
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
call hypermap#map(';z', '\')
call hypermap#map(',q', '!')
call hypermap#map(',w', '@')
call hypermap#map(',e', '#')
call hypermap#map(',r', '$')
call hypermap#map(',a', '&')
call hypermap#map(',s', '"')
call hypermap#map(',d', '*')
call hypermap#map(',f', '%')
call hypermap#map(',z', '_')
call hypermap#map(',x', "'")
call hypermap#map(',c', "^")
call hypermap#map(',v', "`")
noremap! ' :

" sugoi undo
nnoremap U <C-r>

" thanks monaqa and tsuyoshicho
"" code input advanced in insert mode
inoremap <C-v>u <C-r>=nr2char(0x)<Left>

" my ui
nnoremap sm <Cmd>call vimrc#ui#menu()<CR>
nnoremap ml <Cmd>call vimrc#ui#menu('local')<CR>

" 挿入モードで再描画できるようにしてみる
inoremap <C-l> <Cmd>mode<CR>
