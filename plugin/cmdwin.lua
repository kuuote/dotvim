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

local function palette()
  return f.readfile(f.expand('~/.vim/plugin/palette.txt'))
end

local function open()
  local buf = a.nvim_create_buf(false, true)
  a.nvim_buf_set_lines(buf, 0, -1, true, vim.list_extend(history(), palette()))
  vim.keymap.set({ 'n', 'i' }, '<CR>', execute, { buffer = buf })
  local border = vim.tbl_map(function(c)
    return { c, 'String' }
  end, { '.', '.', '.', ':', ':', '.', ':', ':' })
  local opts = {
    relative = 'editor',
    border = border,
    row = math.floor(o.lines / 8),
    col = math.floor(o.columns / 8),
    height = math.floor(o.lines - (o.lines / 4)),
    width = math.floor(o.columns - (o.columns / 4)),
  }
  local win = a.nvim_open_win(buf, 0, opts)
  f.win_execute(win, 'setfiletype cmdwin')
  f.win_execute(win, 'setlocal winhighlight=NormalFloat:Normal')
end

vim.keymap.set('n', 'q:', open, {})
vim.keymap.set('n', 'q;', open, {})
vim.keymap.set('n', '  ', open, {})

vim.call('ddc#custom#patch_filetype', 'cmdwin', 'sources', {
  'file',
  'line',
})
vim.call('ddc#custom#patch_filetype', 'cmdwin', 'sourceOptions', {
  line = {
    converters = {},
    matchers = { 'matcher_substring' },
    sorters = {},
  },
})
