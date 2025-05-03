-- vim.cmd("doautocmd <nomodeline> InsertEnter", vim.fn.bufname())
if false then
	require("insx.preset.standard").setup({})
	return
end
local insx = require("insx")
local esc = require("insx.helper.regex").esc
insx.add("<C-]>", require("insx.recipe.fast_wrap")({ close = ")" }))
local function auto_pair(key, open, close)
	insx.add(
		key,
		require("insx.recipe.auto_pair")({
			open = open,
			close = close,
		})
	)
	local function delete_pair(key)
		insx.add(
			key,
			require("insx.recipe.delete_pair")({
				open_pat = esc(open),
				close_pat = esc(close),
			})
		)
	end
	delete_pair("<C-h>")
	delete_pair("<BS>")
end
auto_pair("'b", "`", "`")
auto_pair("'g", "<", ">")
auto_pair("'f", "(", ")")
auto_pair("'d", "[", "]")
auto_pair("'s", "{", "}")
auto_pair("'w", "'", "'")
auto_pair("'q", '"', '"')
auto_pair("' b", "`", "`;")
auto_pair("' g", "<", ">;")
auto_pair("' f", "(", ");")
auto_pair("' d", "[", "];")
auto_pair("' s", "{", "};")
auto_pair("' w", "'", "';")
auto_pair("' q", '"', '";')

local function fast_break(open, close)
	insx.add(
		"<CR>",
		require("insx.recipe.fast_break")({
			open_pat = esc(open),
			close_pat = esc(close),
		})
	)
end
fast_break("(", ")")
fast_break("[", "]")
fast_break("{", "}")
fast_break("''", "''") -- Nixの文字列がdoubleでTOMLの文字列がtriple

-- 行を跨ぐためにhelper.search.get_next()に差し替えたやつ
-- MIT License
-- Copyright (c) 2025 hrsh7th
local function jump_next(option)
  local kit = require('insx.kit')
  local helper = require('insx.helper')
  local jump_pat = kit.to_array(option.jump_pat)
  return {
    ---@param ctx insx.Context
    enabled = function(ctx)
      local curr_pos = { math.huge, math.huge }
      for _, pat in ipairs(jump_pat) do
        local pos = helper.search.get_next(pat)
        if pos then
          if helper.position.lt(pos, curr_pos) then
            curr_pos = pos
          end
        end
      end
      return curr_pos[1] ~= math.huge
    end,
    ---@param ctx insx.Context
    action = function(ctx)
      local curr_pos = { math.huge, math.huge }
      for _, pat in ipairs(jump_pat) do
        local pos = helper.search.get_next(pat)
        if pos then
          if helper.position.lt(pos, curr_pos) then
            curr_pos = pos
          end
        end
      end
      ctx.move(unpack(curr_pos))
    end,
  }
end
insx.add(
	"<Tab>",
	jump_next({
		jump_pat = {
			[[\%#\s*]] .. esc(")") .. [[\zs]],
			[[\%#$\n\s*]] .. esc(")") .. [[\zs]],
			[[\%#\s*]] .. esc(";") .. [[\zs]],
			[[\%#\s*]] .. esc("]") .. [[\zs]],
			[[\%#$\n\s*]] .. esc("]") .. [[\zs]],
			[[\%#\s*]] .. esc("}") .. [[\zs]],
			[[\%#$\n\s*]] .. esc("}") .. [[\zs]],
			[[\%#\s*]] .. esc(">") .. [[\zs]],
			[[\%#\s*]] .. esc('"') .. [[\zs]],
			[[\%#\s*]] .. esc("'") .. [[\zs]],
			[[\%#\s*]] .. esc("`") .. [[\zs]],
		},
	})
)

local function loadrfile(path)
  loadfile(vim.fn.expand('<script>:h') .. '/' .. path)()
end

loadrfile('./insx/nix.lua')
