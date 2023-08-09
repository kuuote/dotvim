local vimx = require('artemis')
local do_action = vimx.fn.ddu.ui.do_action

local function action(name, params)
  if params == nil then
    return function()
      do_action(name)
    end
  else
    return function()
      do_action(name, params)
    end
  end
end

local M = {}

function M.start()
  require('ddu').start {
    'file',
    ui = 'filer',
    sourceOptions = {
      _ = {
        columns = { 'filename' },
      },
    },
    kindOptions = {
      file = {
        defaultAction = 'open',
      },
    },
  }
end

local mapopts = {
  desc = 'ddu-ui-filer mappings',
  buffer = true,
  nowait = true,
}

local n = function(lhs, rhs)
  vimx.keymap.set('n', lhs, rhs, mapopts)
end

vimx.create_autocmd('FileType', {
  pattern = 'ddu-filer',
  callback = function()
    --
    n('<CR>', action('itemAction'))
    n('o', action('expandItem'))
    n('q', action('quit'))
  end,
})

return M
