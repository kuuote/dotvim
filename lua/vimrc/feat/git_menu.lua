-- おもてなしgitメニュー
-- original idea from denite-gitto
-- https://github.com/hrsh7th/vim-denite-gitto

local function format(entry)
  return entry[1]
end

local function find_worktree()
  local current = vim.fn.expand('%:p:h')
  if vim.fn.getftype(current) ~= 'dir' then
    current = '.'
  end
  local dir = vim.fn.finddir('.git', current .. ';')
  local file = vim.fn.findfile('.git', current .. ';')
  local result = #dir < #file and file or dir
  return vim.fn.fnamemodify(result, ':p'):gsub('%.git/?$', '')
end

local function menu(entries)
  vim.ui.select(entries, {
    format_item = format,
  }, function(entry)
    if entry == nil then
      return
    end
    if entry.callback ~= nil then
      entry.callback()
    elseif entry.menu ~= nil then
      menu(entry.menu)
    end
  end)
end

return function()
  local commands = {
    {
      'status',
      menu = {
        {
          'ddu',
          callback = function()
            require('ddu.git').git_status()
          end,
        },
      },
    },
  }
  local worktree = find_worktree()
  local branches = vim.fn.system(('git -C %s branch --format "%%(HEAD)%%(upstream:track)"'):format(worktree))
  if branches:find('*%[ahead') then
    table.insert(commands, {
      'push',
      callback = function()
        local log = vim.fn.system(('git -C %s log --no-color --oneline @{upstream}..'):format(worktree))
        print(log)
        if vim.fn.confirm(vim.fn.trim(log) .. '\n以上の内容がpushされます、よろしいですか？', '&Yes\n&No', 2) == 1 then
          (vim.command or vim.cmd)('GitPush')
        end
      end,
    })
  end
  menu(commands)
end
