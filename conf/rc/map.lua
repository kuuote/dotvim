local m = require('vimrc.map').define
local nvim = vim.fn.has('nvim') == 1

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
for _, k in ipairs({ 'h', 'j', 'k', 'l' }) do
  m('n', 's' .. k, '<C-w>' .. k)
end

-- 設定開くマン
m('n', '<Space>.', '<Cmd>edit ~/.vim/conf<CR>')

-- Open directory at netrw like plugin
m('n', '<Space>d', '<Cmd>edit %:p:h<CR>')

-- すすむくんもどるくん
m('n', '<Space>h', '^')
m('n', '<Space>l', '$')

if nvim then
  local transparent = function(hlgroup)
    vim.api.nvim_set_hl(0, hlgroup, { bg = 'NONE' })
  end
else
  local transparent = function(hlgroup)
    vim.command('highlight ' .. hlgroup .. ' guibg=NONE')
  end
end

-- 背景を一瞬で透過する
m('n', '<Space>tp', function()
  transparent('EndOfBuffer')
  transparent('NonText')
  transparent('Normal')
  transparent('NormalNC')
end)
