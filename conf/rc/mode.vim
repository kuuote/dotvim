autocmd InsertEnter,CmdlineEnter * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/ic/**/*.vim')
if has('nvim')
  autocmd TermOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
else
  autocmd TerminalOpen * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/t/**/*.vim')
endif
