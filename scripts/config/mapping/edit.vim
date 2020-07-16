"Yの挙動を他の物に寄せる
nnoremap Y y$

nnoremap Q @@

" Useful substitute pattern from https://github.com/tlhunter/vimrc
nnoremap S :<C-u>%s/\v/g<Left><Left>
xnoremap S :s/\v/g<Left><Left>

inoremap <C-l> <del>

" End insertmode on 'jk'
inoremap jk <Esc>

" ISO8601スタイルで日付挿入
noremap! <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>

" easy to use visual-block
xnoremap v <C-v>
