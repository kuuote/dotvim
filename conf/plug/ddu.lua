local act = vim.fn['ddu#custom#action']
local au = require('vimrc.compat.autocmd').define
local cmd = vim.cmd or vim.command
local it = require('kutil.iterate')
local iter = require('vimrc.compat.convert').iter
local vimx = require('artemis')

-- kind_git_status

local function get_worktree(args)
  return args.items[1].action.worktree
end

local function get_pathes(args)
  return it.new(args.items)
    :next(it.map(function(item)
      return item.action.path
    end))
    :collect()
end

local function config()
  act('kind', 'git_status', 'commit', function()
    cmd('Gin commit')
  end)
  act('kind', 'git_status', 'patch', function(args)
    local worktree = get_worktree(args)
    for _, i in iter(args.items) do
      cmd(('tabnew | tcd %s | GinPatch ++no-head %s'):format(worktree, i.action.path))
    end
  end)

  -- ui_ff
  act('ui', 'ff', 'inputAction', function(args)
    local item = vimx.fn['ddu#ui#get_item']()
    local actions = vimx.fn['ddu#get_item_actions'](args.options.name, { item })
    local opt = vimx.fn['ddc#custom#get_buffer']()
    vimx.fn['ddc#custom#set_buffer'] {
      cmdlineSources = { 'list' },
      sources = { 'list' },
      sourceOptions = {
        list = {
          minAutoCompleteLength = 0,
        },
      },
      sourceParams = {
        list = {
          candidates = actions,
        },
      },
    }
    local action = vim.fn.input('action:')
    vimx.fn['ddc#custom#set_buffer'](opt)
    for _, a in ipairs(actions) do
      if action == a then
        vimx.fn['ddu#ui#do_action']('itemAction', {
          name = action,
        })
        return
      end
    end
    print(('`%s`?知らない子ですねぇ'):format(action))
  end)
  end)
end

au('User', {
  pattern = 'DenopsPluginPost:ddu',
  callback = config,
})
config()
