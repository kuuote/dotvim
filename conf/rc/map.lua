local m = require('vimrc.map').define
local nvim = vim.fn.has('nvim') == 1
local cmd = vim.cmd or vim.command
local pum_confirm = require('vimrc.util').pum_confirm

-- 安全にかつ高速に終わるための設定
m({ 'n', 'x', 'o' }, 'Q', '<Cmd>confirm qa<CR>')

-- my ui
m({ 'n' }, 'sm', vim.fn['vimrc#ui#menu'])
m({ 'n' }, 'ml', function()
  vim.fn['vimrc#ui#menu']('local')
end)

-- VimはUSキーボードに優しくないよね
m({ 'n', 'x' }, ';', ':')
m('n', 'q;', 'q:')

-- Prefixの開放
m('n', "'", '<Nop>')
m('n', 's', '<Nop>')

-- Window移動
for _, k in ipairs { 'h', 'j', 'k', 'l' } do
  m('n', 's' .. k, '<C-w>' .. k)
end

-- 設定開くマン
m('n', '<Space>.', '<Cmd>edit ~/.vim/conf<CR>')

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

-- pum.vimとleximaを考慮したegg like return
m('i', '<CR>', function()
  return pum_confirm(function()
    return vim.call('lexima#expand', '<CR>', 'i')
  end)
end, {
  expr = true,
  replace_keycodes = false,
  silent = true,
})
