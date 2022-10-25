local au = require('vimrc.autocmd').define
local fn = require('vimrc.convert').fn
local add = fn['lexima#add_rule']

local function hypermap(from, to)
  local fromlen = #from
  add {
    char = from:sub(fromlen, fromlen),
    at = from:sub(1, fromlen - 1) .. [[\%#]],
    input = to,
  }
end

hypermap(';s', [[<BS><C-r>=lexima#expand('(', 'i')<CR>]])

-- add {
--   char = 's',
--   at = ';\\%#',
--   input = [[<BS><C-r>=lexima#expand('(', 'i')<CR>]],
-- }

au('FileType', {
  pattern = 'lua',
  callback = function()
    -- add endwise rule `if`
    add {
      char = '<CR>',
      at = '^\\s*if\\s.*\\%#',
      input = ' then<CR>',
      input_after = '<CR>end',
      filetype = 'lua',
    }

    -- add endwise rule `for`
    add {
      char = '<CR>',
      at = '^\\s*for\\s.*\\%#',
      input = ' do<CR>',
      input_after = '<CR>end',
      filetype = 'lua',
    }
  end,
  once = true,
})

local clike_filetype = {
  'c',
  'cpp',
  'typescript',
  'typescriptreact',
}

au('FileType', {
  pattern = clike_filetype,
  callback = function()
    -- 1. (
    -- if |
    -- 2. <CR>
    -- if (|) {
    -- }
    -- 3.
    -- if () {
    --   |
    -- }
    for _, stmt in ipairs { 'if', 'for', 'while' } do
      add {
        char = '(',
        at = '^\\s*' .. stmt .. ' \\%#',
        input = '(',
        input_after = ') {<CR>}',
        filetype = clike_filetype,
      }
    end
    add {
      char = '<CR>',
      at = '\\%#.*) {$',
      input = ') {<C-g>u<CR>',
      delete = 3,
      filetype = clike_filetype,
    }
  end,
  once = true,
})

-- こっちは汎用の設定にしておく
-- 末尾の {} に突入して改行するやつ
add {
  char = '<CR>',
  at = '\\%#.*{}$',
  input = '<End><Left><CR><Up><End><CR><C-g>u',
}
