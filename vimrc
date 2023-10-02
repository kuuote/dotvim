set nocompatible
augroup vimrc
  autocmd!
augroup END

let $VIMDIR = expand('<sfile>:p:h')
set runtimepath^=$VIMDIR

if !v:vim_did_enter
  " ./conf/dpp.vim
  source $VIMDIR/conf/dpp.vim
  if get(g:, 'vimrc_dpp_make_state', v:false)
    colorscheme wildcharm
    finish
  endif
endif

set termguicolors
if empty(get(g:, 'colors_name', ''))
  " set background=dark
  " colorscheme retrobox
  set background=light
  colorscheme edge
endif

set tabstop=2
set shiftwidth=2
set expandtab
" 履歴を増やす
set history=10000
" が保存はしない
set viminfo+=:0

" temp mappings
source $VIMDIR/conf/rc/mappings.vim
source $VIMDIR/conf/rc/mode.vim

" temp autocmds
function s:automkdir() abort
  " auto mkdir
  let dir = expand('<afile>:p:h')
  if !isdirectory(dir)
    if confirm(dir .. ' is not found. create it?', "&Yes\n&No", 2) == 1
      call mkdir(dir, 'p')
    endif
  endif
endfunction
autocmd BufWritePre * call s:automkdir()
