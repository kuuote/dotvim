local vimx = require('artemis')

local M = {}

local function attach(name, options)
  return function()
    vimx.fn.lspoints.attach(name, options)
  end
end

M.config = {}

M.server = {}

M.server.denols = {
  attach = attach('denols', {
    cmd = { 'deno', 'lsp' },
    initializationOptions = {
      enable = true,
      unstable = true,
      suggest = {
        autoImports = false,
      },
    },
  }),
}

M.server.luals = {
  attach = attach('luals', {
    cmd = { 'lua-language-server' },
  }),
}

return M
