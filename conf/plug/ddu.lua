local act = vim.fn['ddu#custom#action']
local au = require('vimrc.compat.autocmd').define
local cmd = vim.cmd or vim.command
local it = require('kutil.iterate')
local iter = require('vimrc.compat.convert').iter

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

au('User', {
  pattern = 'DenopsPluginPost:ddu',
  callback = function()
    -- git
    act('kind', 'git_file', 'commit', function()
      cmd('Gin commit')
    end)
    act('kind', 'git_file', 'patch', function(args)
      local worktree = get_worktree(args)
      for _, i in iter(args.items) do
        cmd(('tabnew | tcd %s | GinPatch ++no-head %s'):format(worktree, i.action.path))
      end
    end)
  end
})
