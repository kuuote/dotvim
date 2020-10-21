" vim: fdm=marker
" Startup {{{

" Rewrite $MYVIMRC when using vim in :terminal
let $MYVIMRC = expand("<sfile>")

set encoding=utf-8

let mapleader = ","

" Delete autocommands
augroup vimrc
  autocmd!
augroup END
augroup vimrc_sound
  autocmd!
augroup END

" }}}

" Error catcher {{{
" silent!したいけどエラーは見たいので

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

  if !isdirectory(s:minpac)
    if !executable("git")
      echoerr "minpac and git is not found, quitting now."
      cquit
    endif
    call mkdir(fnamemodify(s:minpac, ":h"), "p")
    execute "!git clone https://github.com/k-takata/minpac.git" s:minpac
    if v:shell_error
      echoerr "cloning minpac is failed, quitting now."
      cquit
    endif
  endif
  packadd minpac

  call minpac#init()
  call minpac#add("k-takata/minpac", {"type": "opt"})

  call vimrc#loadscripts("~/.vim/scripts/plug/**/*.vim")
  if has("nvim")
    call vimrc#loadscripts("~/.vim/scripts/plug.nvim/**/*.vim")
  else
    call vimrc#loadscripts("~/.vim/scripts/plug.vim/**/*.vim")
  endif
endif

" }}}

call vimrc#loadscripts("~/.vim/scripts/config/**/*.vim")
if has("nvim")
  call vimrc#loadscripts("~/.vim/scripts/config.nvim/**/*.vim")
else
  call vimrc#loadscripts("~/.vim/scripts/config.vim/**/*.vim")
endif
