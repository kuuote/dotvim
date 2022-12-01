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

vim.keymap.set('n', 'Q', '<Cmd>cquit 0<CR>')
vim.keymap.set('n', ';', ':')

setup(function(use)
  use { 'Shougo/ddc-source-around' }
  use { 'Shougo/ddc-ui-pum' }
  use { 'Shougo/ddc.vim' }
  use { 'Shougo/dein.vim', merged = 0 }
  use { 'Shougo/pum.vim' }
  use { 'catppuccin/nvim', name = 'catppuccin', merged = 0 }
  use { 'vim-denops/denops.vim' }
end)
vim.call('dein#recache_runtimepath')

vim.cmd('colorscheme catppuccin-mocha')
vim.call('ddc#custom#set_global', {
  sources = { 'around' },
  ui = 'pum',
})
vim.call('ddc#enable')

vim.keymap.set('i', '<Tab>', '<Cmd>call pum#map#insert_relative(1)<CR>')
vim.call('pum#set_option', 'use_complete', true)
