local M = {}

local history = {}
local notifiers = {}

function M.add_notify(msg, level)
  table.insert(history, 1, ('%s:%s'):format(level, msg))
end

function M.notify(msg, level)
  M.add_notify(msg, level)
  for _, n in ipairs(notifiers) do
    n(msg, level)
  end
end

function M.subscribe(notifier)
  table.insert(notifiers, notifier)
end

function M.count()
  return #history
end

function M.print(clear)
  vim.pretty_print(history)
  if clear then
    history = {}
  end
end

require('artemis').keymap.set('n', '<Space>np', function()
  M.print(true)
end)

return M
