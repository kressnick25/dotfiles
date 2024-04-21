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
		dependencies = { "mason.nvim" },
		event = "BufReadPost",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"yamlls",
					"gopls",
				},
				-- auto install associated LSP on file open
				automatic_installation = false,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason-lspconfig.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		config = function()
			local cap = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.pyright.setup({
				capabilities = cap,
			})
			lspconfig.gopls.setup({
				capabilites = cap,
			})
			lspconfig.tsserver.setup({
				capabilities = cap,
			})
			lspconfig.lua_ls.setup({
				capabilities = cap,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			lspconfig.yamlls.setup({})

			-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

			-- Use LspAttach command to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Buffer local mappings
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					-- formatting handled by null-ls
					--
					-- vim.keymap.set("n", "<space>f", function()
					-- 	vim.lsp.buf.format({ async = true })
					-- end, opts)

					-- Handled by nvim-cmp.lua
					--
					-- enable completion triggered by <c-x><c-o>
					-- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				end,
			})
		end,
	},
	{
        "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
		dependencies = { "nvim-lspconfig", "mason-lspconfig.nvim", "mason.nvim" },
		-- event = { "BufReadPost", "BufNewFile" },
		-- cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		opts = {
			server = {
				cmd = {
					"sonarlint-language-server",
					-- Ensure that sonarlint-language-server uses stdio channel
					"-stdio",
					-- '-analyzers',
					-- paths to the analyzers you need, using those for python and java in this example
					-- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
					-- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
					-- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
				},
			},
			filetypes = {
				-- Tested and working
				"groovy",

				"python",
				"cpp",
				"java",
			},
		},
	},
}
