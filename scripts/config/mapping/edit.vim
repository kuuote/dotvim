"Yの挙動を他の物に寄せる
nnoremap Y y$

nnoremap Q @@

" Useful substitute pattern from https://github.com/tlhunter/vimrc
nnoremap S :<C-u>%s/\v/g<Left><Left>
xnoremap S :s/\v/g<Left><Left>

inoremap <C-l> <del>

" ISO8601スタイルで日付挿入
noremap! <C-r><C-d> _<C-r>=strftime("%Y%m%dT%H%M%S")<CR>

" easy to use visual-block
xnoremap v <C-v>
" from TornaxO7's config
" undo the undo with a latter U
map U <C-r>

" セミコロン入れるのだるいでござる～
nnoremap <Space>; A;<Esc>

"" Automatically indent with i and A
"" by yuki-ycino
nnoremap <expr> i len(getline('.')) ? "i" : "cc"
nnoremap <expr> A len(getline('.')) ? "A" : "cc"
