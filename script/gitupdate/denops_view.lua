local vimx = require('artemis')
vimx.fn.denops.request('vimrc', 'load', {
  vimx.fn.expand('$DOTVIM/script/gitupdate/denops_view.ts'),
  {
    tasks = './out.json',
    -- tasks = '/data/code/deno/gitupdate/out.json',
    task = './task/fget2.sh',
  },
})
