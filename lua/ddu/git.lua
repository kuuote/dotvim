local M = {}

function M.git_status()
  require('ddu').start {
    'git_status',
    name = 'git',
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
