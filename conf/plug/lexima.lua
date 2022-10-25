local au = require('vimrc.autocmd').define
local fn = require('vimrc.convert').fn
local add = fn['lexima#add_rule']

-- local function hypermap(from, to)
--   local fromlen = #from
--   add {
--     char = from:sub(fromlen, fromlen),
--     at = from:sub(1, fromlen - 1) .. [[\%#]],
--     input = to,
--   }
-- end
-- 
-- hypermap(';s', [[<BS><C-r>=lexima#expand('(', 'i')<CR>]])
-- simulates altercmd by lexima
-- port of https://scrapbox.io/vim-jp/lexima.vim%E3%81%A7Better_vim-altercmd%E3%82%92%E5%86%8D%E7%8F%BE%E3%81%99%E3%82%8B
local function altercmd(original, alternative)
  -- space
  add {
    mode = ':',
    at = [[\v^('<, '>)?]] .. original .. [[\%#$]],
    char = '<Space>',
    input = '<C-w>' .. alternative .. '<Space>',
  }

  -- cr
  add {
    mode = ':',
    at = [[\v^('<, '>)?]] .. original .. [[\%#$]],
    char = '<CR>',
    input = '<C-w>' .. alternative .. '<CR>',
  }
end

altercmd('ee', 'e!')
altercmd('r\\%[un]', 'QuickRun')
altercmd('cap\\%[ture]', 'Capture')
altercmd('gy', 'Gina browse --yank --exact :')
altercmd('git', 'Gin')

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
