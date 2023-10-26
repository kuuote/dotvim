" 複数イベントを定義すると個別にonce適用されるので全部ModeChanged使う
autocmd ModeChanged *:[ic]* ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/ic/**/*.vim')
autocmd ModeChanged *:*[ovV\x16]* ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/ov/**/*.vim')
if has('nvim')
  autocmd TermOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
else
  autocmd TerminalOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
endif
