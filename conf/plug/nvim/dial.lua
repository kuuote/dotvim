local augend = require('dial.augend')
require('dial.config').augends:register_group {
  default = {
    augend.integer.alias.decimal, -- nonnegative decimal number
    augend.integer.alias.hex, -- nonnegative hex number
    augend.constant.alias.bool, -- boolean value (true <-> false)
  },
}
