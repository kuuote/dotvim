"open parent directory of buffer when browsing
set browsedir=buffer

"λとかをちゃんと表示させる
set ambiwidth=double

let s:savefile = expand("~/.vim/scripts/config/tmp/guifont.vim")

function! s:savefont() abort
  let f = getbufvar("%", "&guifont")
  call mkdir(expand("~/.vim/scripts/config/tmp"), "p")
  call writefile(["if has('gui_running')", "let &guifont = " .. string(f), "endif"], s:savefile)
endfunction

autocmd OptionSet guifont call s:savefont()

command! Jiskan set guifont=JF\ Dot\ jiskan16s-2000\ 12
