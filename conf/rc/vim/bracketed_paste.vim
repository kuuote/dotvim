" ぶらぶらけっと from `:h xterm-bracketed-paste`
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
exec "set t_PS=\e[200~"
exec "set t_PE=\e[201~"
