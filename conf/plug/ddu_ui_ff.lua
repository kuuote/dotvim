local vimx = require('artemis')

local setup = require('vimrc.plug.ddu_ui_ff').setup
local setup_filter = require('vimrc.plug.ddu_ui_ff').setup_filter

vimx.create_autocmd('FileType', {
  pattern = 'ddu-ff',
  callback = setup,
})

setup() -- FileType ddu-ffで呼び出してるので一度はここで呼ぶ必要がある

vimx.create_autocmd('FileType', {
  pattern = 'ddu-ff-filter',
  callback = setup_filter,
})
