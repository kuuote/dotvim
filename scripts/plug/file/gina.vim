call minpac#add('lambdalisue/gina.vim')

packadd gina.vim

nnoremap gl :<C-u>Gina log<CR>
nnoremap gs :<C-u>Gina status<CR>

try
  call gina#custom#mapping#nmap(
  \ 'status', 'cm',
  \ ':<C-u>Gina commit -v --opener=tabedit<CR>',
  \ {'noremap': 1, 'silent': 1},
  \)

  " HEAD表示なくてもおk
  call gina#custom#mapping#nmap(
  \ 'status', 's',
  \ '<Plug>(gina-patch-oneside-tab)',
  \ {'silent': 1, 'nowait': 1},
  \)
catch
  call vimrc#add_exception()
endtry

function! s:preview_apply(text, ft) abort
  if !bufexists(b:prbuf)
    return
  endif
  call setbufvar(b:prbuf, "&ft", a:ft)
  call deletebufline(b:prbuf, 1, "$")
  call setbufline(b:prbuf, 1, a:text)
endfunction

let s:preview_job = -1
let s:preview_acc = []

function! s:preview_cb(ch, msg) abort
  call add(s:preview_acc, a:msg)
endfunction

function! s:preview_change() abort
  " Gitのメッセージ位置を取ってdiffするかファイルを直接読むかを決める
  let lines = getline(1, "$")
  let nostaged = index(lines, "Changes not staged for commit:")
  let untracked = index(lines, "Untracked files:")
  let line = getline(".")
  " Ginaはファイル部分をエスケープしてくれているので利用する
  if stridx(line, "\<Esc>") != -1
    let linepos = line(".")
    if untracked != -1 && linepos > untracked
      " untrackedより先はファイルを直接開く
      try
        " エスケープシーケンスを利用して切り出し
        let line = substitute(line, "\\v.*\<Esc>\\[\\d+m(.*)\<Esc>.*", "\\1", "")
        if line =~# "/$"
          let res = readdir(line)
        else
          let res = readfile(line)
        endif
        call s:preview_apply(res, "text")
      catch
        echo [v:exception, v:throwpoint]
        call add(g:vimrc_errors, [v:exception, v:throwpoint])
      endtry
    else
      " もうちょっと上手くできた気がするけど面倒だし当分は放置
      let line = substitute(line, "\\v[^:]*:\\s*", "", "")
      let line = substitute(line, "\\v\<Esc>.*", "", "")
      let opt = (nostaged != -1 && linepos > nostaged) ? "" : "--staged"
      silent! call job_stop(s:preview_job, "kill")
      let s:preview_acc = []
      " TODO:neovimでは動かんのでそのうちなんとかする
      let preview_job = job_start(split(printf("git diff %s %s", opt, line)), {
      \ "close_cb": {ch->s:preview_apply(s:preview_acc, "diff")},
      \ "out_cb": funcref("s:preview_cb"),
      \ })
    endif
  endif
endfunction

function! s:preview_open() abort
  execute "lcd" system("git rev-parse --show-toplevel")
  let curwin = win_getid()
  new
  let prbuf = bufnr("%")
  setlocal buftype=nofile bufhidden=hide noswapfile
  call win_gotoid(curwin)
  let b:prbuf = prbuf
  autocmd CursorMoved <buffer> call s:preview_change()
endfunction

augroup vimrc
  autocmd vimrc FileType gina-status nnoremap <buffer> pr :<C-u>call <SID>preview_open()<CR>
  autocmd vimrc FileType gina-status setlocal number relativenumber
augroup END
