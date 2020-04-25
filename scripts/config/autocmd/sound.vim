let s:keywave = expand("~/.vim/wav/kbd.wav")
let s:vimrc_sound_cursor = [1, 1]
function! s:keysound() abort
  let c = [line("."), col(".")]
  if s:vimrc_sound_cursor != c
    call vimrc#play(s:keywave)
    let s:vimrc_sound_cursor = c
  endif
endfunction

augroup vimrc_sound
  autocmd CursorMoved * call s:keysound()
  autocmd CursorMovedI * call s:keysound()

  let s:del_sounds = glob("~/.vim/wav/delete/*.wav", v:true, v:true)

  function! s:delsound() abort
    if v:event.operator !~ "[cd]"
      return
    endif
    call vimrc#play(s:del_sounds[float2nr(1.0 * len(s:del_sounds) * vimrc#rand() / pow(2, 32))])
  endfunction

  autocmd TextYankPost * call s:delsound()

  " ソフトウェアたるもの起動音はもちろん必要だよね
  autocmd VimEnter * call vimrc#play(expand("~/.vim/wav/pc98.wav"))

augroup END
