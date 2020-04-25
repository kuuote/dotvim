"Yの挙動を他の物に寄せる
nnoremap Y y$

nnoremap Q @@

" Reselect visual block after adjusting indentation
xnoremap < <gv
xnoremap > >gv

" Useful substitute pattern from https://github.com/tlhunter/vimrc
nnoremap S :<C-u>%s/\v/g<Left><Left>
vnoremap S :s/\v/g<Left><Left>

inoremap <C-l> <del>

" End insertmode on 'jk'
inoremap jk <Esc>

" ISO8601スタイルで日付挿入
cnoremap <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>
inoremap <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>
