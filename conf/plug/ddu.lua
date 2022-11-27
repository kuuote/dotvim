local au = require('vimrc.compat.autocmd').define
local it = require('kutil.iterate')
local act = vim.fn['ddu#custom#action']
local cmd = vim.cmd or vim.command

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
      local cmdargs = get_pathes(args)
      table.insert(cmdargs, 1, 'GinPatch')
      cmd(table.concat(cmdargs, ' '))
    end)
  end
})
