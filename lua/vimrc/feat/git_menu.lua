-- おもてなしgitメニュー
-- original idea from denite-gitto
-- https://github.com/hrsh7th/vim-denite-gitto

local cmd = vim.command or vim.cmd

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
          cmd('GitPush')
        end
      end,
    })
  end
  require('vimrc.menu').select(commands)
end
