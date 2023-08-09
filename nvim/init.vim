" とりあえずはVimと共用で
if !empty($vimprofile)
  let profile = expand('<sfile>:p:h') .. '/profiles/' .. $vimprofile
  execute printf('set runtimepath^=%s', profile)
  execute printf('set runtimepath+=%s/after', profile)
  execute printf('set packpath^=%s', profile)
  execute printf('source %s/vimrc', profile)
else
  set runtimepath^=~/.vim
  set runtimepath+=~/.vim/after
  set packpath^=~/.vim
  source ~/.vim/vimrc
endif
