local vimx = require('artemis')
vim.cmd('!$VIMDIR/script/gitupdate/snap/shot')
vim.cmd.redraw()
vimx.fn.vimrc.denops.request('loader', 'load', {
  vimx.fn.expand('$VIMDIR/script/gitupdate/denops_view.ts'),
  {
    -- 指定しなかったらdpp.vimのデータを読む
    -- tasks = './tasks.json',
    task = './task/fget.sh',
  },
})
-- $VIMDIR/script/gitupdate/snap/diff
