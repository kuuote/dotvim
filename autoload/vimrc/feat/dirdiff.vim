function vimrc#feat#dirdiff#do(a, b) abort
  let a = fnamemodify(a:a, ':p')
  let b = fnamemodify(a:b, ':p')

  tabnew
  setlocal buftype=nofile bufhidden=hide noswapfile cursorbind
  execute 'lcd' a
  call setline(1, systemlist('find -type f | sort | xargs md5sum -b'))
  diffthis
  nnoremap <buffer> <nowait> <CR> <Cmd>call <SID>open()<CR>

  botright vnew
  setlocal buftype=nofile bufhidden=hide noswapfile cursorbind
  execute 'lcd' b
  call setline(1, systemlist('find -type f | sort | xargs md5sum -b'))
  diffthis
  nnoremap <buffer> <nowait> <CR> <Cmd>call <SID>open()<CR>

  let t:dirdiff = [a, b]
endfunction

function! s:open() abort
  let [a, b] = t:dirdiff

  let line = getline('.')
  let path = line[stridx(line, './') + 2:]

  execute '-tabnew' a .. path
  diffthis

  execute 'botright vnew' b .. path
  diffthis
endfunction
