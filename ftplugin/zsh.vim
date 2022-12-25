if bufname() =~# '/tmp/zsh.*zsh'
  " 複数回呼ばれるとfeedkeysが重複するのでインクルードガード
  if exists('b:zsh_edit_command_line')
    finish
  endif
  let b:zsh_edit_command_line = 1
  set showtabline=2
  set tabline=%!getcwd()
  " call timer_start(0, {...->execute('startinsert!')})
lua << EOS
local map = require('vimrc.compat.map').define
local convert = require('vimrc.compat.convert')

map({'n', 'i'}, '<C-e>', '<Cmd>xall<CR>')

convert.call('ddc#custom#set_buffer', {
  sources = { 'file', 'zsh', 'around' },
  sourceOptions = {
    zsh = {
      minAutoCompleteLength = 1,
    },
  },
})
EOS
  call feedkeys('A', 'ni')
endif
