let s:cut = '# ------------------------ >8 ------------------------'

let s:diff = systemlist('cd ' .. expand('%:p:h:h') .. ' ; git diff --cached')
let s:log = systemlist('cd ' .. expand('%:p:h:h') .. ' ; git log --oneline')->map('"# " .. v:val')

call deletebufline('%', 1, '$')
call setbufline('%', 2, flatten([s:cut, s:diff, s:log]))
