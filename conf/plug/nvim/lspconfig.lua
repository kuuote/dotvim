vim.api.nvim_create_autocmd('LspAttach', {
	group = 'vimrc',
	callback = function(ev)
		local opts = {
			buffer = true,
		}
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		vim.keymap.set('n', 'ma', '<Cmd>DduSelectorCall lsp_codeAction<CR>', opts)
		if client.server_capabilities.documentFormattingProvider then
			vim.keymap.set('n', 'mf', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
		end
	end,
})

local server = {
	lua = 'lua_ls',
	typescript = 'denols',
}

function _LspStart()
	local name = server[vim.bo.filetype]
	if name then
		vim.lsp.start(vim.lsp.config[name])
	end
end
