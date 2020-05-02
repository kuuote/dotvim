" QuickRun用に雑バッファ作るやつ
function! s:scratch(filetype, usethis, mods) abort
  execute a:usethis ==# "!" ? "enew" : a:mods .. " new"
  setlocal buftype=nofile bufhidden=hide noswapfile
  let &filetype = a:filetype
endfunction

command! -bang -nargs=1 Scratch call s:scratch(<q-args>, "<bang>", "<mods>")

" うるさい黙れ
command! ShutUp autocmd! vimrc_sound

let s:jobs = {}
let s:plugdir = "~/.vim/pack/temp/start"
function! s:gitclone_end(ch) abort
  let j = ch_getjob(a:ch)
  packloadall
  helptags ALL
  echomsg s:jobs[j] .. " installed."
endfunction

function! s:echo(_, msg) abort
  echo a:msg
endfunction

function! s:gitclone_temp(url) abort
  let cmd = printf('mkdir -p %s ; cd %s ; git clone --depth=1 --progress %s |& stdbuf -i0 -o0 tr "\r" "\n"', s:plugdir, s:plugdir, a:url)
  let j = job_start(["bash", "-c", cmd], {
        \ "out_cb": funcref("s:echo"),
        \ "close_cb": funcref("s:gitclone_end"),
        \ })
  let s:jobs[j] = a:url
endfunction

command! -nargs=1 Templug call s:gitclone_temp(<f-args>)
