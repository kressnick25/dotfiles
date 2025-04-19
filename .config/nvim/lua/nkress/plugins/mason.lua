return {
	{
		"williamboman/mason.nvim",
		event = "BufReadPost",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
		event = { "BufReadPost", "BufNewFile" },
		opts = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			---@type MasonLspconfigSettings
			return {
				ensure_installed = {
					"lua_ls",
					"pyright",
					"yamlls",
					"gopls",
					"stylua",
					"black",
					"prettier",
				},
				-- auto install associated LSP on file open
				automatic_installation = false,
				handlers = {
					-- this first function is the "default handler"
					-- it applies to every language server without a "custom handler"
					function(server_name)
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end,
				},
			}
		end,
	},
}
