local vimx = require('artemis')
local do_action = vimx.fn.ddu.ui.do_action
local isnvim = vim.fn.has('nvim') == 1
local part = require('kutil.function').partition_keyvalue

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

local function item_action(tbl)
  local args, params = part(tbl)
  params[vim.type_idx] = vim.types.dictionary
  local farg = {
    name = args[1],
    params = params,
  }
  return function()
    do_action('itemAction', farg)
  end
end

local mapopts = {
  desc = 'ddu-ui-ff mappings',
  buffer = true,
  nowait = true,
}

local n = function(lhs, rhs)
  vimx.keymap.set('n', lhs, rhs, mapopts)
end

local i = function(lhs, rhs)
  vimx.keymap.set('i', lhs, rhs, mapopts)
end

local M = {}

M.setup_table = {
  _ = function()
    n('>', action('chooseAction'))
    n('K', action('useKensaku'))
    n('a', action('myInputAction'))
    n('i', action('openFilterWindow'))
    n('q', action('quit'))
    -- preview
    -- n('p', action('preview'))
    n('[', action('previewExecute', { command = 'normal! \x15' })) -- <C-u>
    n(']', action('previewExecute', { command = 'normal! \x04' })) -- <C-d>
    n('P', action('toggleAutoAction'))
  end,
}

M.setup_table.file = function()
  n('t', item_action { 'open', command = 'tabedit' })
  n('s', item_action { 'open', command = 'split' })
  n('v', item_action { 'open', command = 'vsplit' })
  n('<C-q>', function()
    do_action('clearSelectAllItems')
    do_action('toggleAllItems')
    item_action { 'quickfix' }()
  end)
end

M.setup_table.git_status = function()
  n('c', item_action { 'commit' })
  n('d', item_action { 'diff' })
  n('D', item_action { 'diff', { cached = true } })
  n('h', item_action { 'add' })
  n('l', item_action { 'reset' })
  n('p', item_action { 'patch' })
end

M.setup = function()
  M.setup_table['_']()
  for _, name in require('vimrc.compat.convert').iter(vimx.fn.split(vimx.b.ddu_ui_name, ':')) do
    local fn = M.setup_table[name]
    if fn ~= nil then
      fn()
    end
  end
end

M.setup_filter_table = {
  _ = function()
    -- vimx.keymap.set({ 'n', 'i' }, '<CR>', function()
    --   vimx.cmd('stopinsert')
    --   action('closeFilterWindow')()
    -- end, mapopts)
    i('<C-j>', function()
      vim.call('ddu#ui#ff#execute', [[call cursor(line('.')+1, 0)]])
      vimx.cmd('redraw!')
    end)
    i('<C-k>', function()
      vim.call('ddu#ui#ff#execute', [[call cursor(line('.')-1, 0)]])
      vimx.cmd('redraw!')
    end)
    -- for fzf and jis keyboard
    i(':', [[']])
    -- leximaが'を展開しちゃうので上書き
    i([[']], [[']])
  end,
}

M.setup_filter = function()
  M.setup_filter_table['_']()
  for _, name in ipairs(vimx.fn.split(vimx.b.ddu_ui_name, ':')) do
    local fn = M.setup_filter_table[name]
    if fn ~= nil then
      fn()
    end
  end
end

M.util = {
  action = action,
  item_action = item_action,
  nmap = n,
}

return M
