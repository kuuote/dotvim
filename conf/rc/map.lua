local m = require('vimrc.map').define

-- 安全にかつ高速に終わるための設定
m({'n', 'x', 'o'}, 'Q', '<Cmd>confirm qa<CR>')

-- my ui
m({'n'}, 'sm', vim.fn['vimrc#ui#menu'])
m({'n'}, 'ml', function() vim.fn['vimrc#ui#menu']('local') end)
