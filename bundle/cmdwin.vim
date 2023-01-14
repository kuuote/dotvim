" re-implement cmdwin as a few lines.
-tabnew
setlocal buftype=nofile bufhidden=hide noswapfile syntax=vim
let s:hist = range(histnr(':'), 0, -1)->map('histget(":", v:val)')->filter('!empty(v:val)') + readfile(expand('~/.vim/plugin/palette.txt'))
call setline(2, s:hist)
nnoremap <buffer> <nowait> <CR> <Esc><Cmd>let g:cmdwin_cmd = getline('.')<CR><Cmd>tabclose<CR><Cmd>if g:cmdwin_cmd !~# '^:' <Bar> call histadd(':', g:cmdwin_cmd) <Bar> endif<CR><Cmd>execute g:cmdwin_cmd<CR>
inoremap <buffer> <nowait> <CR> <Esc><Cmd>let g:cmdwin_cmd = getline('.')<CR><Cmd>tabclose<CR><Cmd>if g:cmdwin_cmd !~# '^:' <Bar> call histadd(':', g:cmdwin_cmd) <Bar> endif<CR><Cmd>execute g:cmdwin_cmd<CR>

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
