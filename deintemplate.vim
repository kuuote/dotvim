let g:vimrc = expand('<sfile>:p')
let s:dir = '/data/vim'

set rtp+=/data/vim/repos/github.com/Shougo/dein.vim

let g:dein#auto_recache = 1
let g:dein#install_progress_type = 'floating'
let g:dein#cache_directory = '/tmp/_dein'

if dein#load_state(s:dir)
  call dein#begin(s:dir, [g:vimrc])

  call dein#add('Shougo/dein.vim')
  call dein#add('sainnhe/edge')

  call dein#end()
  call dein#save_state()
endif

set noswapfile

nnoremap <Space>. <Cmd>edit `=g:vimrc`<CR>
nnoremap <Space>d <Cmd>edit %:p:h<CR>
nnoremap <Space>s <Cmd>update<CR>
nnoremap Q <Cmd>confirm qa<CR>

set background=light
colorscheme edge
