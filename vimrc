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
    set bg=light
    colorscheme wildcharm
    finish
  endif
endif

call vimrc#inline#load('$VIMDIR/conf/rc/*.vim')
call vimrc#inline#load('$VIMDIR/local/rc/*.vim')

set termguicolors
if empty(get(g:, 'colors_name', ''))
  set background=light
  colorscheme edge
endif

set tabstop=2
set shiftwidth=2
set expandtab

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
