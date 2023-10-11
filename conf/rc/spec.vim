if has('nvim')
  call vimrc#inline#load('$VIMDIR/conf/rc/nvim/*')
else
  call vimrc#inline#load('$VIMDIR/conf/rc/vim/*')
endif
