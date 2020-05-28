function! vimrc#add_exception() abort
  let e = get(g:, "vimrc_errors", [])
  call add(e, [v:throwpoint, v:exception])
endfunction

"pathに指定したものをglobして:sourceする
function! vimrc#loadscripts(path) abort
  for f in sort(glob(a:path, v:true, v:true))
    try
      execute "source" f
    catch
      call vimrc#add_exception()
    endtry
  endfor
endfunction

"キーバインドを入れ替えるやつ
function! vimrc#swapkey(mode, a, b)
  for mode in split(a:mode, '\zs', 1)
    exe printf("%snoremap %s %s", mode, a:a, a:b)
    exe printf("%snoremap %s %s", mode, a:b, a:a)
  endfor
endfunction

"Quickfixウィンドウをトグルする
function! vimrc#qftoggle()
  for b in tabpagebuflist()
    if getbufvar(b, "&buftype") ==# "quickfix"
      cclose
      return
    endif
    copen
    exe "normal! " .. "\<C-w>p"
  endfor
endfunction

if has("nvim")
  function! vimrc#spawn(cmd) abort
    call jobstart(["sh", "-c", a:cmd])
  endfunction
else
  function! vimrc#spawn(cmd) abort
    call job_start(["sh", "-c", a:cmd])
  endfunction
endif

if has("sound")
  function! vimrc#play(sndfile) abort
    call sound_playfile(a:sndfile)
  endfunction
elseif executable("paplay")
  function! vimrc#play(sndfile) abort
    call vimrc#spawn(printf("paplay %s", a:sndfile))
  endfunction
else
  function! vimrc#play(sndfile) abort
    autocmd! vimrc_sound
  endfunction
endif

" jobを利用したsystemlist()の代用品
function! vimrc#systemlist(cmd) abort
  let j = job_start(["sh", "-c", a:cmd], {"out_mode":"raw"})
  let c = job_getchannel(j)
  let a = ch_read(c)
  while v:true
    let s = ch_read(c)
    if s == ""
      break
    endif
    let a ..= s
  endwhile
  return split(a, "\n")
endfunction

function! vimrc#rand() abort
  if has("patch-8.2.233")
    return rand()
  else
    if !exists("s:g")
      let v = vital#vital#new().load("Random")
      let s:g = v.Random.new("Xor128")
    endif
    return s:g.next()
  endif
endfunction

function! vimrc#autoloadname() abort
  let cfile = expand("%:p")
  let acc = [fnamemodify(cfile, ":t:r")]
  while v:true
    let pfile = fnamemodify(cfile, ":h")
    if pfile =~# "autoload$" || cfile ==# pfile
      break
    endif
    call insert(acc, fnamemodify(pfile, ":t"))
    let cfile = pfile
  endwhile
  return join(acc, "#") .. "#"
endfunction
