let s:subscribed = 0

let g:gina_preview_oneside = get(g:, "gina_preview_oneside", 1)

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

function! s:on(scheme) abort
  if a:scheme ==# "patch"
    call win_gotoid(t:winid_gina)
    execute "vertical resize" &columns / 3
    return
  elseif a:scheme !=# "status"
    return
  elseif !get(t:, "gina_preview", 0)
    return
  endif
  call win_gotoid(t:winid_gina)
  silent! only
  let l = substitute(getline("."), "\<Esc>[^m]\\+m", "", "g")
  let file = l[3:]
  silent! execute "Gina patch --opener=vsplit" g:gina_preview_oneside ? "--oneside" : "" file
endfunction

function! s:open(usetab) abort
  if a:usetab
    tab split
  endif
  let t:gina_preview = 1
  call s:status()
  let t:winid_gina = win_getid()

  nnoremap <buffer> j j:call <SID>on("status")<CR>
  nnoremap <buffer> k k:call <SID>on("status")<CR>
  " autocmd CursorMoved <buffer> call s:on("status")
  if !s:subscribed
    call gina#core#emitter#subscribe("command:called", function("s:on"))
    let s:subscribed = 1
  endif
endfunction

command! -bang GinaPreview call s:open(<bang>1)
