call minpac#add('thinca/vim-template')
let g:template_basedir = fnamemodify($MYVIMRC, ":h")

" 以下helpよりコピペ

autocmd User plugin-template-loaded
\ silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge

autocmd vimrc User plugin-template-loaded
	\    if search('<+CURSOR+>')
	\  |   execute 'normal! "_da>'
	\  | endif
