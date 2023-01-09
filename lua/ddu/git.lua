local M = {}

function M.git_status()
  require('ddu').start {
    'git_status',
    name = 'git',
    sourceParams = {
      git_status = {
        worktree = vim.fn.expand('%:p'),
      },
    },
    uiParams = {
      ff = {
        autoAction = {
          name = 'preview',
        },
      },
    },
  }
end

function M.git_diff(params)
  params = params or {}
  require('ddu').start {
    {
      name = 'git_diff',
      params = params,
    },
    name = 'file',
    uiParams = {
      ff = {
        autoAction = {
          name = 'preview',
        },
      },
    },
  }
end

function M.git_diff_buffer()
  require('ddu').start {
    'git_diff_buffer',
    name = 'file',
    uiParams = {
      ff = {
        autoAction = {
          name = 'preview',
        },
      },
    },
  }
end

return M
