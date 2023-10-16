local vimx = require('artemis')
vimx.fn.vimrc.denops.request('loader', 'load', {
  vimx.fn.expand('~/.vim/script/gitupdate/denops_view.ts'),
  {
    tasks = './out.json',
    -- tasks = '/data/code/deno/gitupdate/out.json',
    task = './task/fetch.sh',
  },
})
