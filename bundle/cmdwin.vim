" re-implement cmdwin as a few lines.

function! s:execute() abort
  let s:cmd = getline('.')
  tabclose
  autocmd CmdlineEnter * ++once call setcmdline(s:cmd)
  call feedkeys(":\<CR>", s:cmd =~# '^:' ? 'n' : 'nt')
endfunction

-tabnew
setlocal buftype=nofile bufhidden=hide noswapfile syntax=vim
let s:hist = range(histnr(':'), 0, -1)->map('histget(":", v:val)')->filter('!empty(v:val)') + readfile(expand('~/.vim/plugin/palette.txt'))
call setline(2, s:hist)
nnoremap <buffer> <nowait> <CR> <Esc><Cmd>call <SID>execute()<CR>
inoremap <buffer> <nowait> <CR> <Esc><Cmd>call <SID>execute()<CR>

function! s:dirpath() abort
  call ddc#custom#set_buffer(#{sources: ['file'], specialBufferCompletion: v:true})
  let c = fnamemodify(bufname('#'), ':p')
  if !isdirectory(c)
    let c = fnamemodify(c, ':h')
  endif
  let c = substitute(c, '/*$', '/', '')
  call feedkeys(c, 'n')
endfunction

inoremap <buffer> <nowait> <C-p> <Cmd>call <SID>dirpath()<CR>

call ddc#custom#patch_buffer('specialBufferCompletion', v:true)
call ddc#custom#patch_buffer('sources', ['cmdline'])
