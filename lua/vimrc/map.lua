local callback = require("vimrc.callback")

local M = {}

M.fns = {}
local fnidx = 1

if vim.fn.has("nvim") == 1 then
	M.define = vim.keymap.set
else
	M.define = function(mode, lhs, rhs, opts)
		if type(mode) == "string" then
			mode = { mode }
		end

		if type(rhs) == "function" then
      local id = callback.register(id)
			M.fns[fnidx] = rhs
			rhs = string.format("<Cmd>lua require('vimrc.callback').call(%d)<CR>", fnidx)
			fnidx = fnidx + 1
		end

		opts = opts or {}
		local mods = ""

		for _, m in ipairs({ "buffer", "nowait", "silent", "script", "expr" }) do
			if opts[m] then
				mods = mods .. "<" .. m .. ">"
			end
		end

		for _, m in ipairs(mode) do
			local cmd = string.format("%snoremap %s %s %s", m, mods, lhs, rhs)
			vim.command(cmd)
		end
	end
end

return M
