local au = require('vimrc.compat.autocmd').define
local group = require('vimrc.compat.autocmd').group
local map = require('vimrc.compat.map').define
local vimcall = require('vimrc.compat.convert').call
local eval = vim.eval or vim.api.nvim_eval

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

local function set_eval(opts)
  if opts.set_buffer then
    save()
    table.insert(resetters, function()
      vimcall('vimrc#ddc#reset')
    end)
  end
  vimcall('vimrc#ddc#reset')
  opts = opts or {}
  if opts.gather then
    vim.g['vimrc#ddc#gather'] = opts.gather
  end
  if opts.get_complete_position then
    vim.g['vimrc#ddc#get_complete_position'] = opts.get_complete_position
  end
  if opts.on_complete_done then
    vim.g['vimrc#ddc#on_complete_done'] = opts.on_complete_done
  end
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

au('User', {
  pattern = 'DenopsPluginPost:ddc',
  callback = function()
    vimcall('ddc#custom#set_context_global', function()
      -- Vimは死ぬので
      if not is_nvim then
        return
      end
      if vim.fn.mode() == 'c' and vim.fn.getcmdtype() == ':' then
        local line = vim.fn.getcmdline()
        if line:match('he?l?p? %a*$') then
          return {
            cmdlineSources = { 'cmdline_help' },
          }
        end
        if line:match('^%a*$') then
          set_eval({
            gather = function()
              local i = require('kutil.iterate')
              local cmds = i.new(eval('execute("command")->split("\\n")[1:]'))
              :next(i.map(function(line)
                return {
                  word = line:sub(5):match('^%a+'),
                }
              end))
              :next(i.filter(function(cand)
                return cand.word ~= nil
              end))
              :collect()
              return cmds
            end,
          })
          return {
            cmdlineSources = { 'eval' },
          }
        end
      end
    end)
  end,
})
