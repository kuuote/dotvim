" 比較できるように書き込む時間ごとにオリジンと書き込む対象のコピーを取る
let g:dup_origin_dir = get(g:, "dup_origin_dir", "/tmp/orig")
let g:dup_write_dir = get(g:, "dup_write_dir", "/tmp/dup")

let s:time = -1

function! s:normalize(path) abort
  return substitute(resolve(fnamemodify(a:path, ":p")), "/", "%", "g")
endfunction

function! s:read(path) abort
  let buf = []
  silent! let buf = readfile(a:path)
  return buf
endfunction

function! s:save(dir, data) abort
  let subdir = printf("%s/%s", a:dir, s:normalize(bufname()))
  call mkdir(subdir, "p")
  call writefile(a:data, printf("%s/%s", subdir, s:time))
endfunction

augroup dup
  autocmd!
  autocmd BufWritePre * let s:time = localtime()
  autocmd BufWritePre * call s:save(g:dup_origin_dir, s:read(bufname()))
  autocmd BufWritePre * call s:save(g:dup_write_dir, getline(1, "$"))
augroup END
