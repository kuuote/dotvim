" Treat buffers from stdin as scratch.
" from https://github.com/airblade/dotvim/tree/edad9fe8793b7c9266039b4cf85272a9b10cd9cb/
autocmd vimrc StdinReadPost * :set buftype=nofile

function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf("%sx%sx%sx", perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction

" シバン付いてるファイルに実行権限を与える
autocmd vimrc BufWritePost * if getline(1) =~# "^#!" | call s:chmod(expand("<afile>")) | endif

" Automatically create missing directories
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

" 初回検索時のみwrapscanする
augroup vimrc
  autocmd CmdlineEnter,CmdwinEnter / set wrapscan
  autocmd CmdlineLeave,CmdwinLeave / call timer_start(0, {->execute("set nowrapscan")}) " timer使っているのはCmdlineを抜けた直後に走る検索でwrapscanを有効にするため
augroup END
