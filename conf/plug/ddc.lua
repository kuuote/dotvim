local au = require('vimrc.compat.autocmd').define
local group = require('vimrc.compat.autocmd').group
local map = require('vimrc.compat.map').define
local vimcall = require('vimrc.compat.convert').call

local resetters = {}
local customs = {}

local function save()
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] == nil then
    customs[bufnr] = vimcall('ddc#custom#get_buffer')
  end
end

local function reset()
  local bufnr = vim.fn.bufnr()
  if customs[bufnr] ~= nil then
    vimcall('ddc#custom#set_buffer', customs[bufnr])
    customs[bufnr] = nil
  end
  for _, cb in ipairs(resetters) do
    cb()
  end
  resetters = {}
end

local toggroup = 'vimrc#completoggle'
group(toggroup, {})

-- resetter

-- ソースの自動切り替えを一時的に止めたい
local completoggle = (function()
  local enabled = true
  local enable
  if is_nvim then
    enable = function()
      au({ 'CmdlineLeave', 'InsertLeave' }, {
        group = toggroup,
        callback = function()
          vim.fn.timer_start(0, function()
            if vim.fn.mode() == 'n' then
              reset()
            end
          end)
        end,
      })
    end
  else
    enable = function()
      au('SafeState', {
        group = toggroup,
        callback = function()
          if vim.fn.mode() == 'n' then
            reset()
          end
        end,
      })
    end
  end
  enable()
  return function()
    group(toggroup, {})
    enabled = not enabled
    if enabled then
      enable()
    end
    print('completoggle ' .. (enabled and 'enabled' or 'disabled'))
  end
end)()

local function change_source(name)
  save()
  vimcall('ddc#custom#set_buffer', {
    cmdlineSources = { name },
    sources = { name },
    specialBufferCompletion = true,
  })
end

local function set_list(candidates, callback)
  save()
  local id = vim.call('denops#callback#register', callback or function() end)
  table.insert(resetters, function()
    vim.call('denops#callback#unregister', id)
  end)
  vimcall('ddc#custom#set_buffer', {
    cmdlineSources = { 'list' },
    sources = { 'list' },
    sourceParams = {
      list = {
        candidates = candidates,
        callback = id,
      },
    },
  })
end

map({ 'c', 'i' }, '<C-X>', function()
  require('vimrc.menu').menu {
    info = 'select completion source',
    items = {
      ['<C-F>'] = {
        info = 'file',
        fn = function()
          change_source('file')
        end,
      },
      ['<C-J>'] = {
        info = 'suconv',
        fn = function()
          change_source('suconv')
          vimcall('ddc#custom#patch_buffer', {
            sourceOptions = {
              suconv = {
                converters = {},
                matchers = {},
                sorters = {},
                isVolatile = true,
                maxItems = 20,
              },
            },
          })
        end,
      },
      ['<C-R>'] = {
        info = 'toggle reset at leave',
        fn = completoggle,
      },
      ['<C-V>'] = {
        info = 'necovim',
        fn = function()
          vimcall('dein#source', 'neco-vim')
          change_source('necovim')
        end,
      },
      i = {
        info = 'imports',
        fn = function()
          set_list(vim.fn.readfile(vim.fn.expand('~/.vim/conf/plug/compe/generated')))
        end,
      },
      p = {
        info = 'plugin-name',
        fn = function()
          local repos = {}
          local dein = vimcall('dein#get')
          for _, p in pairs(dein) do
            repos[#repos + 1] = p.repo
          end
          set_list(repos)
        end,
      },
    },
  }
end)
