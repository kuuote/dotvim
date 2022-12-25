vim.g.vimrc = vim.fn.expand('<sfile>:p')

local dir = '/data/vim'

vim.opt.runtimepath:append('/data/vim/repos/github.com/Shougo/dein.vim')

vim.g['dein#cache_directory'] = '/tmp/_dein'
vim.g['dein#install_progress_type'] = 'floating'
vim.g['dein#types#git#clone_depth'] = 0

local function partition(tbl)
  local ip = {}
  local kv = {}
  for k, v in pairs(tbl) do
    if type(k) == 'number' then
      ip[k] = v
    else
      kv[k] = v
    end
  end
  return ip, kv
end

local function _use(def)
  local args, kwargs = partition(def)
  kwargs[vim.type_idx] = vim.types.dictionary
  vim.call('dein#add', args[1], kwargs)
end

local function setup(fn)
  vim.call('dein#begin', dir)
  fn(_use)
  vim.call('dein#end')
end

for _, k in ipairs({'h', 'j', 'k', 'l'}) do
  vim.keymap.set('n', '<C-' .. k .. '>', '<C-w>' .. k)
end
vim.keymap.set('n', '1', '1<C-w><C-w>')
vim.keymap.set('n', '2', '2<C-w><C-w>')
vim.keymap.set('n', '3', '3<C-w><C-w>')
vim.keymap.set('n', 'Q', '<Cmd>confirm qa<CR>')
vim.keymap.set('n', '<Space>s', '<Cmd>update<CR>')

setup(function(use)
  use { 'Shougo/dein.vim', merged = 0 }
  use { 'catppuccin/nvim', name = 'catppuccin', merged = 0 }
  use { 'vim-denops/denops.vim' }
  use { 'lambdalisue/gin.vim' }
  use { '~/.vim/bundle/gin-preview.vim' }
end)

vim.call('dein#recache_runtimepath')
vim.cmd('colorscheme catppuccin-latte')
vim.cmd('runtime! plugin/gin_preview.vim')
vim.cmd('GinPreview')
