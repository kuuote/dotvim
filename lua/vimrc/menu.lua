-- which key like menu for Vim(if_lua)/Neovim

local it = require('kutil.iterate')
local M = {}
local pum = nil
local nvim = vim.fn.has('nvim') == 1
local fn = require('vimrc.compat.convert').fn
local redraw = vim.command and function()
  vim.command('redraw')
end or function()
  vim.cmd('redraw!')
end

local function floating(info, items)
  local text = it.new(items)
    :next(it.map(function(item)
      return ('[%s] %s'):format(item[1], item[2].info)
    end))
    :collect()
  table.insert(text, 1, info)
  local columns = vim.go and vim.go.columns or vim.eval('&g:columns')
  local lines = vim.go and vim.go.lines or vim.eval('&g:lines')
      local width = math.floor(columns - (columns / 4))
      local height = math.floor(lines - (lines / 4))
  if nvim then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)
    pum = vim.api.nvim_open_win(buf, false, {
      relative = 'editor',
      style = 'minimal',
      col = math.floor(columns / 8),
      row = math.floor(lines / 8),
      width = width,
      height = height,
      zindex = 10000,
    })
  else
    pum = fn.popup_create(text, {
      pos = 'center',
      minwidth = width,
      minheight = height,
      zindex = 10000,
    })
  end
end

local function close()
  if pum ~= nil then
    if nvim then
      vim.api.nvim_win_close(pum, true)
    else
      vim.fn.popup_close(pum)
    end
    pum = nil
  end
end

function M.which(defs)
  close()
  local items = {}
  defs.items = defs.items or {}
  for k, m in pairs(defs.items) do
    items[#items + 1] = { k, m }
  end
  table.sort(items, function(a, b)
    return a[1] < b[1]
  end)
  floating(defs.info, items)
  redraw()
  local k = vim.fn.keytrans(vim.fn.getcharstr())
  close()
  if k == '<Esc>' then
    return
  end
  local item = defs.items[k]
  if item == nil then
    return M.which(defs)
  end
  if item.fn ~= nil then
    return item.fn()
  end
  return M.which(item)
end

local function format(entry)
  return entry[1]
end

function M.select(entries)
  vim.ui.select(entries, {
    format_item = format,
  }, function(entry)
    if entry == nil then
      return
    end
    if entry.callback ~= nil then
      entry.callback()
    elseif entry.menu ~= nil then
      select(entry.menu)
    end
  end)
end

return M
