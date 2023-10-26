" 複数イベントを定義すると個別にonce適用されるので全部ModeChanged使う
autocmd ModeChanged *:[ic]* ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/ic/**/*.vim')
if has('nvim')
  autocmd TermOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
else
  autocmd TerminalOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
endif
