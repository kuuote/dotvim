" 複数イベントを定義すると個別にonce適用されるので全部ModeChanged使う
autocmd vimrc ModeChanged *:[ic]* ++once call vimrc#inline#load('$MYVIMDIR/conf/rc/mode/ic/**/*.vim')
autocmd vimrc ModeChanged *:*[ovV\x16]* ++once call vimrc#inline#load('$MYVIMDIR/conf/rc/mode/ov/**/*.vim')
if has('nvim')
  autocmd vimrc TermOpen * ++once call vimrc#inline#load('$MYVIMDIR/conf/rc/mode/t/**/*.vim')
else
  autocmd vimrc TerminalOpen * ++once call vimrc#inline#load('$MYVIMDIR/conf/rc/mode/t/**/*.vim')
endif
