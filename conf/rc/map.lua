local au = require('vimrc.compat.autocmd').define
local m = require('vimrc.compat.map').define
local cmd = vim.cmd or vim.command

-- 安全にかつ高速に終わるための設定
m({ 'n', 'x', 'o' }, 'Q', '<Cmd>confirm qa<CR>')
m({ 'i', 'c' }, '<C-q>', '<Cmd>confirm qa<CR>')

-- VimはUSキーボードに優しくないよね
m({ 'n', 'x' }, "'", ':')
m('n', "q'", 'q:')

-- Prefixの開放
m('n', 's', '<Nop>')
m('n', 'q', '<Nop>')

-- Window移動
au('WinNew', {
  once = true,
  callback = function()
    for _, k in ipairs { 'h', 'j', 'k', 'l' } do
      m('n', 's' .. k, '<C-w>' .. k)
      m('n', '<C-' .. k .. '>', '<C-w>' .. k)
    end
  end,
})

-- 設定開くマン
m('n', '<Space>.', '<Cmd>edit $DOTVIM/conf<CR>')

-- Open directory at netrw like plugin
m('n', '<Space>d', '<Cmd>edit %:p:h<CR>')

-- すすむくんもどるくん
m('n', '<Space>h', '^')
m('n', '<Space>l', '$')

local transparent = function(hlgroup)
  cmd('highlight ' .. hlgroup .. ' guibg=NONE')
end

-- 背景を一瞬で透過する
m('n', '<Space>tp', function()
  transparent('EndOfBuffer')
  transparent('NonText')
  transparent('Normal')
  transparent('NormalNC')
end)

-- 挿入モード
au('InsertEnter', {
  once = true,
  callback = function()
    -- 括弧などから抜ける
    m('i', '<C-l>', function()
      local pos = vim.fn.searchpos([=[\v%(\)|]|}|'|"|`|<end\a*)]=], 'cez')
      vim.fn.cursor(pos[1], pos[2] + 1)
      vim.cmd('doautocmd <nomodeline> TextChangedI foo') -- 補完をトリガーする
    end)

    local condmap = require('vimrc.condmap')

    condmap.define {
      key = 'fallback',
      lhs = '<Tab>',
      priority = condmap.prior.fallback,
      fn = function()
        return '\x14' -- <C-t>
      end,
    }

    condmap.define {
      key = 'fallback',
      lhs = '<S-Tab>',
      priority = condmap.prior.fallback,
      fn = function()
        return '\x04' -- <C-d>
      end,
    }
  end,
})

-- cmdlineでキャンセルした際に履歴を残さない
m('c', '<Esc>', '<C-u><C-c>')

-- フルパス入れるやつ
-- 何も無い所で実行するとディレクトリを入力
-- その直後(正確にはパス区切りがカーソルの前にある状況)で実行するとファイル部分を入力する
m({'c', 'i'}, '<C-p>', function()
  local pos, line
  if vim.fn.mode() == 'c' then
    pos = vim.fn.getcmdpos()
    line = vim.fn.getcmdline()
  else
    pos = vim.fn.col('.')
    line = vim.fn.getline('.')
  end
  local left = line:sub(pos - 1, pos)

  local k
  if left == '/' then
    k = vim.fn.expand('%:p:t')
  else
    k = vim.fn.expand('%:p:h') .. '/'
  end
  vim.fn.feedkeys(k, 'n')
end)
