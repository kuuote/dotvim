local au = require('vimrc.compat.autocmd').define
local fn = require('vimrc.compat.convert').fn
local add = fn['lexima#add_rule']

--@ ,を二度押すと左に移動する
add {
  char = ',',
  at = [[,\%#]],
  input = '<Left>',
}

--@ altercmd
local altercmd = require('vimrc.plug.lexima').altercmd

altercmd('cap\\%[ture]', 'Capture')
altercmd('d', 'DeolCurrent')
altercmd('ee', 'e!')
altercmd('git', 'Gin')
altercmd('gy', 'Gina browse --yank --exact :')
altercmd('pe', 'Partedit -filetype')
altercmd('r\\%[un]', 'QuickRun')

--@ Cっぽい言語
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
    -- if (|) {}
    -- 3. input this way...
    -- if () {
    --   |
    -- }
    for _, stmt in ipairs { 'if', 'for', 'while' } do
      add {
        char = '(',
        at = [[^\s*]] .. stmt .. [[\s\%#]],
        input = '(',
        input_after = ') {}',
        filetype = clike_filetype,
      }
    end
    -- add {
    --   char = '<CR>',
    --   at = '\\%#.*) {$',
    --   input = ') {<C-g>u<CR>',
    --   delete = 3,
    --   filetype = clike_filetype,
    -- }
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

--@ enter with pum
local pum_confirm = require('vimrc.util').pum_confirm

-- pumとleximaを考慮したegg like return
-- leximaのマッピングを上書きするための物なのでこちらに置いておく
require('vimrc.compat.map').define('i', '<CR>', function()
  return pum_confirm(function()
    return vim.call('lexima#expand', '<CR>', 'i')
  end)
end, {
  expr = true,
  replace_keycodes = false,
  silent = true,
})

--@ hypermap (補完を破壊するので一旦無効化)
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

--@ Lua
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

    -- add endwise rule `while`
    add {
      char = '<CR>',
      at = '^\\s*while\\s.*\\%#',
      input = ' do<CR>',
      input_after = '<CR>end',
      filetype = 'lua',
    }
  end,
  once = true,
})

--@ p
local function define_p(filetype, input, input_after)
  au('FileType', {
    pattern = filetype,
    callback = function()
      add {
        char = '<Space>',
        at = [[^\s*p\%#]],
        input = '<BS>' .. input,
        input_after = input_after,
        filetype = filetype,
      }
    end,
  })
end

define_p('lua', 'vim.pretty_print(', ')')
define_p('vim', 'PrettyPrint ', '')
define_p({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, 'console.log(', ');')

--@ Rust
au('FileType', {
  pattern = 'rust',
  callback = function()
    add {
      char = [[']],
      at = [['\%#]],
      input = '<BS>::',
      filetype = 'rust',
    }
  end,
})

