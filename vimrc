augroup vimrc
  autocmd!
augroup END

if !v:vim_did_enter
  source ~/.vim/conf/dein.vim
endif

filetype plugin indent on
syntax enable

call vimrc#load_scripts('~/.vim/conf/rc/**/*.vim')
call vimrc#load_scripts(printf('~/.vim/conf/%s/rc/**/*.vim', has('nvim') ? 'nvim' : 'vim'))
call vimrc#load_scripts('~/.vim/conf/plug/**/*.vim')
call vimrc#load_scripts(printf('~/.vim/conf/%s/plug/**/*.vim', has('nvim') ? 'nvim' : 'vim'))

if empty(get(g:, 'colors_name', ''))
  set bg=dark
  colorscheme edge
endif
