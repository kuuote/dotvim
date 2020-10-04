function! s:time_part() abort
  return expand("%:p:t")
endfunction

function! s:real_part() abort
  let p = expand("%:p:h:t")
  return p
endfunction

function! s:diff(a, b) abort
  tabedit `=a:a`
  diffthis
  vsplit `=a:b`
  diffthis
endfunction

let s:dir_template = "%s/%s/%s"

function! s:diff_dup() abort
  let t = s:time_part()
  let r = s:real_part()
  let o = printf(s:dir_template, g:dup_origin_dir, r, t)
  let d = printf(s:dir_template, g:dup_write_dir, r, t)
  call s:diff(o, d)
endfunction

function! s:diff_origin() abort
  let o = substitute(s:real_part(), "@", "/", "g")
  call s:diff(o, expand("%:p"))
endfunction

command! DupDiff call s:diff_dup()
command! DupDiffOrigin call s:diff_origin()
