return {
	"nvimtools/none-ls.nvim",
    event = 'BufEnter',
    keys = {
        {'<leader>gf', vim.lsp.buf.format, desc = 'Format buffer'}
    },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.autopep8,
                null_ls.builtins.formatting.prettier
			},
		})
	end,
}
