local fn = require('vimrc.convert').fn
local add = fn['lexima#add_rule']

local M = {}

-- simulates altercmd by lexima
-- port of https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
function M.altercmd(original, alternative)
  -- space
  add {
    mode = ':',
    at = [[^\('<,'>\)\?]] .. original .. [[\%#$]],
    char = '<Space>',
    input = '<C-w>' .. alternative .. '<Space>',
  }

  -- cr
  add {
    mode = ':',
    at = [[^\('<,'>\)\?]] .. original .. [[\%#$]],
    char = '<CR>',
    input = '<C-w>' .. alternative .. '<CR>',
  }
end

return M
