local a = vim.api
local f = vim.fn
local o = vim.o

local function history()
  local t = {}
  local max = f.histnr(':')
  for i = 1, f.histnr(':') do
    local h = f.histget(':', i)
    if #h ~= 0 then
      table.insert(t, 1, h)
    end
  end
  return t
end

local function execute()
  local line = a.nvim_get_current_line()
  vim.cmd('stopinsert')
  vim.cmd('close')
  f.histadd(':', line)
  vim.cmd(line)
end

local function open()
  local buf = a.nvim_create_buf(false, true)
  a.nvim_buf_set_lines(buf, 0, -1, true, history())
  vim.keymap.set({'n', 'i'}, '<CR>', execute, { buffer = buf })
  local border = vim.tbl_map(function (c)
    return {c, "String"}
  end, {'.', '.', '.', ':', ':', '.', ':', ':'})
  local opts = {
    relative = 'editor',
    border = border,
    row = math.floor(o.lines / 4),
    col = math.floor(o.columns / 4),
    height = math.floor(o.lines / 2),
    width = math.floor(o.columns / 2),
  }
  local win = a.nvim_open_win(buf, 0, opts)
  f.win_execute(win, 'setfiletype cmdwin')
  f.win_execute(win, 'setlocal winhighlight=NormalFloat:None')
end

vim.keymap.set({'n'}, 'q:', open, {})
vim.keymap.set({'n'}, 'q;', open, {})
vim.keymap.set({'n'}, '  ', open, {})
