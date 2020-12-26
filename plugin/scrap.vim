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
    execute printf("syn match ScrapIndent%d /%s/hs=e", i%6, repeat("\t", i))
  endfor
  nnoremap <buffer> <silent> <CR> :<C-u>call <SID>jump()<CR>
  setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
endfunction

function! s:init_scrap_highlight() abort
  hi! ScrapIndent0 guibg=#BAFFFF
  hi! ScrapIndent1 guibg=#FFCACA
  hi! ScrapIndent2 guibg=#FFFFBA
  hi! ScrapIndent3 guibg=#CACAFF
  hi! ScrapIndent4 guibg=#CAFFCA
  hi! ScrapIndent5 guibg=#FFBAFF
endfunction

function! s:jump() abort
  let w = winsaveview()
  let a = getreg("a")
  call setreg("a", "")
  normal! "ayi[
  let res = getreg("a")
  call setreg("a", a)
  call winrestview(w)
  if !empty(res)
    edit `=expand("%:h") .. "/" .. res .. ".scp"`
  endif
endfunction

function! scrap#open(dir) abort
  let date = substitute(system("date +%F"), "\n", "", "")
  " let t = localtime()
  " if execute("language time") =~ "en"
  "   let t += 32400
  " endif
  edit `=printf("%s/%s.scp", a:dir, date)`
endfunction

autocmd BufRead,BufNewFile *.scp setfiletype scrap
autocmd FileType scrap call s:init_scrap_mode()
autocmd ColorScheme * call s:init_scrap_highlight()
