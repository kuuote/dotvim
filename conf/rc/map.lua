local m = require('vimrc.map').define

-- 安全にかつ高速に終わるための設定
m({'n', 'x', 'o'}, 'Q', '<Cmd>confirm qa<CR>')
