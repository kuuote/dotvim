local vimx = require('artemis')
vimx.cmd('!$VIMDIR/script/gitupdate/snap/shot')
vimx.cmd.redraw()
vimx.fn.vimrc.denops.request('loader', 'load', {
  vimx.fn.expand('$VIMDIR/script/gitupdate/denops_view.ts'),
  {
    -- 指定しなかったらdpp.vimのデータを読む
    -- tasks = './tasks.json',
    task = './task/fget.sh',
  },
})
vimx.create_autocmd('User', {
  pattern = 'GitUpdatePost',
  callback = function()
    vimx.cmd.terminal('$VIMDIR/script/gitupdate/snap/diff')
  end,
  once = true,
})
