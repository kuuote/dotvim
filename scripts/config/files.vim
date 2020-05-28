if !v:vim_did_enter
  const s:dir = $HOME .. "/.vim/tmp//"
  const s:bdir = $HOME .. "/.vim/backup//"
  const s:udir = $HOME .. "/.vim/undo//"
endif

"swap
call mkdir(s:dir, "p")
let &directory = s:dir

"backup
call mkdir(s:bdir, "p")
set backup
set backupcopy=yes
let &backupdir = s:bdir
augroup vimrc
  " From help
  autocmd BufWritePre * let &bex = '-' .. strftime("%Y%b%d%X") .. '~'
augroup END

"viminfo
set viminfo+=n~/.vim/viminfo

"undo
call mkdir(s:udir, "p")
let &undodir = s:udir
set undofile

"!が必要なコマンドを実行した時に確認をとってくれる
set confirm

set fileencodings=utf-8,sjis,cp932,euc-jp
set fileformats=unix,dos,mac
