if has('unnamedplus')
  "ヤンクとかペースト時にOSのクリップボードを使ってくれるやつ
  set clipboard=unnamedplus
elseif executable("xclip")
  "X11有効になってないVim使ってるときにxclipがあればそれにヤンクしたものを流す
  autocmd vimrc TextYankPost * call system("xclip -selection clipboard", @")
endif

function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf("%sx%sx%sx", perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction

" シバン付いてるファイルに実行権限を与える
autocmd vimrc BufWritePost * if getline(1) =~# "^#!" | call s:chmod(expand("<afile>")) | endif

" Automatically create missing directories {{{
" copied from https://github.com/lambdalisue/dotfiles/blob/master/nvim/init.vim
function! s:auto_mkdir(dir, force) abort
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir) || a:dir =~# '^suda:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \)
      if empty(result)
        echohl WarningMsg
        echo 'Canceled'
        return
      endif
    finally
      call inputrestore()
      echohl None
    endtry
  endif
  call mkdir(a:dir, 'p')
endfunction
autocmd vimrc BufWritePre *
      \ call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}

" for quick-scope
" quickly CursorHold call but not quick save swapfile
autocmd InsertEnter * set updatetime&
autocmd InsertLeave * set updatetime=100
set updatetime=100
