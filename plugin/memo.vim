let s:hls = [
\ "Normal",
\ "Statement",
\ "PreProc",
\ "Constant",
\ "Type",
\ "Identifier",
\]

let g:memodir = get(g:, "memodir", $HOME .. "/memo")

function! s:hl() abort
  for i in range(100)
    let ii = i * &shiftwidth
    execute printf("syn match %s %s", s:hls[i%len(s:hls)], string(repeat(" ", ii) .. ".*"))
  endfor
endfunction

function! memo#open(dir) abort
  let t = localtime()
  if execute("language time") =~ "en"
    let t += 32400
  endif
  edit `=printf("%s/%s.scp", a:dir, strftime("%F", t))`
endfunction

autocmd BufRead,BufNewFile *.scp setfiletype scrap
autocmd FileType scrap call s:hl()
