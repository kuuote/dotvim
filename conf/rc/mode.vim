autocmd InsertEnter,CmdlineEnter * ++once call vimrc#inline#load('$VIMDIR/conf/rc/mode/ic/**/*.vim')
