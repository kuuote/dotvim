-- 起動時にrequireしたくないねん
local _ = getmetatable(vim)
local __index = _.__index
_.__index = function(self, key)
  if key == 'treesitter' then
    require('vimrc.treesitter_hack')
    _.__index = __index
  end
  return __index(self, key)
end
