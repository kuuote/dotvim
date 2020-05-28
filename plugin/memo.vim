let s:hls = [
\ "Normal",
\ "Statement",
\ "PreProc",
\ "Constant",
\ "Type",
\ "Identifier",
\]

let g:memodir = get(g:, "memodir", $HOME .. "/memo")

function! s:init_scrap_mode() abort
  for i in range(100)
    let ii = i * &shiftwidth
    execute printf("syn match %s %s", s:hls[i%len(s:hls)], string(repeat(" ", ii) .. ".*"))
  endfor
  nnoremap <buffer> <silent> <CR> :<C-u>call <SID>jump()<CR>
endfunction

function! s:jump() abort
  let w = winsaveview()
  let a = getreg("a")
  call setreg("a", "")
  normal! "ayi[
  let res = getreg("a")
  if !empty(res)
    edit `=expand("%:h") .. "/" .. res .. ".scp"`
  else
    call winrestview(w)
  endif
  call setreg("a", a)
endfunction

function! memo#open(dir) abort
  let t = localtime()
  if execute("language time") =~ "en"
    let t += 32400
  endif
  edit `=printf("%s/%s.scp", a:dir, strftime("%F", t))`
endfunction

autocmd BufRead,BufNewFile *.scp setfiletype scrap
autocmd FileType scrap call s:init_scrap_mode()
