" vim: fdm=marker
" Startup {{{

" Rewrite $MYVIMRC when using vim in :terminal
let $MYVIMRC = expand("<sfile>")

set encoding=utf-8

let mapleader = ","

" Delete autocommands
augroup vimrc
  autocmd!
augroup vimrc_sound
  autocmd!
augroup END

" }}}

" Error catcher {{{
" silent!したいけどエラーは見たいので

let g:vimrc_errors = []
function! s:catch(args) abort
  try
    execute a:args
  catch
    call vimrc#add_exception()
  endtry
endfunction

command! -nargs=* Catch call s:catch("<args>")

" }}}

" Plugin {{{

if !v:vim_did_enter
  let s:minpac = fnamemodify("~/.vim/pack/minpac/opt/minpac", ":p")

  if !isdirectory(s:minpac) && executable("git")
    call mkdir(fnamemodify(s:minpac, ":h"), "p")
    execute "!git clone https://github.com/k-takata/minpac.git" s:minpac
  endif
  packadd minpac

  if exists("*minpac#init")
    call minpac#init()
    call minpac#add("k-takata/minpac", {"type": "opt"})

    call vimrc#loadscripts("~/.vim/scripts/plug/**/*.vim")
    if has("nvim")
      call vimrc#loadscripts("~/.vim/scripts/plug.nvim/**/*.vim")
    else
      call vimrc#loadscripts("~/.vim/scripts/plug.vim/**/*.vim")
    endif
  endif

  " 現在のディレクトリがプラグインであればrtpに加える
  for dir in [
  \ "./autoload",
  \ "./colors",
  \ "./ftplugin",
  \ "./indent",
  \ "./plugin",
  \ "./syntax",
  \ ]
    if isdirectory(dir)
      set rtp^=.
      break
    endif
  endfor
endif

" }}}

call vimrc#loadscripts("~/.vim/scripts/config/**/*.vim")
if has("nvim")
  call vimrc#loadscripts("~/.vim/scripts/config.nvim/**/*.vim")
else
  call vimrc#loadscripts("~/.vim/scripts/config.vim/**/*.vim")
endif
