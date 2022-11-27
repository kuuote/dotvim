local au = require('vimrc.compat.autocmd').define
local map = require('vimrc.compat.map').define
local vimcall = require('vimrc.compat.convert').call

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
end

-- resetter
if is_nvim then
  au({ 'CmdlineLeave', 'InsertLeave' }, {
    callback = function()
      vim.fn.timer_start(0, function()
        if vim.fn.mode() == 'n' then
          reset()
        end
      end)
    end,
  })
else
  au('SafeState', {
    callback = function()
      if vim.fn.mode() == 'n' then
        reset()
      end
    end,
  })
end

local function change_source(name)
  save()
  vimcall('ddc#custom#set_buffer', {
    cmdlineSources = { name },
    sources = { name },
    specialBufferCompletion = true,
  })
end

local function set_list(candidates)
  save()
  vimcall('ddc#custom#set_buffer', {
    cmdlineSources = { 'list' },
    sources = { 'list' },
    sourceParams = {
      list = {
        candidates = candidates,
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
      ['<C-V>'] = {
        info = 'necovim',
        fn = function()
          vimcall('dein#source', 'neco-vim')
          change_source('necovim')
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
