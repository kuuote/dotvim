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
auto_pair("'g", "<", ">")
auto_pair("'f", "(", ")")
auto_pair("'d", "[", "]")
auto_pair("'s", "{", "}")
auto_pair("'w", "'", "'")
auto_pair("'q", '"', '"')
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
