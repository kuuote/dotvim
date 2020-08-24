function! s:status() abort
  let repo = finddir(".git", expand("%:p:h") .. ";")
  if !empty(repo)
    let repo = fnamemodify(repo, ":p")
    let root = fnamemodify(repo, ":h:h") " ディレクトリ名が展開された場合末尾に/が付く
    execute "tcd" root
    Gina status -s
  else
    throw "Not a git repository."
  endif
endfunction

function! s:boot(...) abort
  if !get(t:, "gina_preview", 0)
    return
  endif
  let oldid = t:termid

  let l = substitute(getline("."), "\<Esc>[^m]\\+m", "", "g")
  let type = l[0:2]
  let file = l[3:]

  if type[0] == "M"
    let cmd = ["git", "diff", "--cached"]
  elseif type[1] == "M"
    let cmd = ["git", "diff"]
  elseif file[-1:] == "/"
    let cmd = ["tree"]
  else
    let cmd = ["cat"]
  endif

  let t:termid = term_start(cmd + [file], {"hidden": 1})
  call win_gotoid(t:winid_term)
  execute "buffer" t:termid
  setlocal nonumber norelativenumber
  call win_gotoid(t:winid_gina)

  silent! execute "bdelete!" oldid
endfunction

function! s:open(usetab) abort
  if a:usetab
    tab split
  endif
  let t:gina_preview = 1
  call s:status()
  let t:winid_gina = win_getid()
  belowright vsplit
  let t:winid_term = win_getid()
  call win_gotoid(t:winid_gina)
  execute "vertical resize" &columns / 3

  let t:termid = -1
  autocmd CursorMoved <buffer> call s:boot()
  call gina#core#emitter#subscribe("command:called", function("s:boot"))
endfunction

command! -bang GinaPreview call s:open(<bang>1)
