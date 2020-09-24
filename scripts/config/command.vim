" QuickRun用に雑バッファ作るやつ
function! s:scratch(mods, usethis, range) abort
  let text = []
  if a:range[0]
    let text = getline(a:range[1], a:range[2])
  endif

  " カレントバッファのファイルタイプをそのまま適用させる
  let filetype = &filetype

  execute a:usethis ? "enew" : a:mods .. " new"
  setlocal buftype=nofile bufhidden=hide noswapfile
  let &filetype = filetype
  call setline(1, text)
endfunction

command! -bang -nargs=? -range Scratch call s:scratch(<q-args>, <bang>0, [<range>, <line1>, <line2>])

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

" fugitiveのGwriteもどき
function! s:gwrite() abort
  update
  let repo = finddir(".git", expand("%:p:h") .. ";")
  if !empty(repo)
    let repo = fnamemodify(repo, ":p")
    let root = fnamemodify(repo, ":h:h") " ディレクトリ名が展開された場合末尾に/が付く
    call  system(printf("git --work-tree=%s --git-dir=%s add %s", root, repo, expand("%:p")))
  else
    echoerr "not a git repository"
  endif
endfunction

nnoremap <silent> gw :<C-u>call <SID>gwrite()<CR>

" カレントファイルを行ごとに履歴に挿入する
function! s:bulkhist(type) abort
  let t = empty(a:type) ? ":" : a:type
  for l in getline(1, "$")
    call histadd(t, l)
  endfor
endfunction

command! -nargs=? BulkHistAdd call s:bulkhist(<q-args>)
