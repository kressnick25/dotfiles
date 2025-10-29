require("nkress.set")
require("nkress.remap")

local colorscheme = "vague"

-- plugins
vim.pack.add({
	-- colorschemes
	"https://github.com/vague2k/vague.nvim",
	--
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/saghen/blink.compat",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	{ src = "https://github.com/akinsho/toggleterm.nvim", version = "v2.13.1" },

	-- dependencies
	"https://github.com/nvim-tree/nvim-web-devicons", -- alpha.nvim, nvim-tree.lua, lualine
	"https://github.com/nvim-lua/plenary.nvim", -- harpoon
	"https://github.com/rafamadriz/friendly-snippets", -- blink.cmp
})

-- alpha dashboard
local dashboard = require("alpha.themes.startify")
dashboard.section.header.val = {
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                     ]],
	[[       ████ ██████           █████      ██                     ]],
	[[      ███████████             █████                             ]],
	[[      █████████ ███████████████████ ███   ███████████   ]],
	[[     █████████  ███    █████████████ █████ ██████████████   ]],
	[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
}
require("alpha").setup(dashboard.opts)

-- blink
require("blink.compat").setup({})
require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	keymap = {
		-- https://cmp.saghen.dev/configuration/keymap#super-tab
		preset = "super-tab",
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = {
		menu = {
			border = "rounded",
			winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,

			window = {
				border = "rounded",
			},
		},
	},

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "jenkinsfile" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100, -- highest
			},
			jenkinsfile = {
				name = "jenkinsfile",
				module = "blink.compat.source",
				score_offset = -3,
				opts = {
					-- jenkins_url = "http://localhost:8080"
				},
			},
		},
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- conform (formatting)
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		python = { "ruff_format" },
		lua = { "stylua" },
		javascript = { "prettier" },
	},
	default_format_opts = {
		lsp_format = "fallback",
		stop_after_first = true,
	},
})
-- format buffer
vim.keymap.set("n", "<leader>gf", function()
	conform.format()
end)

-- gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true,
	numhl = true,
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	current_line_blame = true,
})

-- lazydev
require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

-- lualine
require("lualine").setup({
	theme = colorscheme,
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diagnostics" },
		lualine_c = {},
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { "diff" },
		-- %f shows full file path, use 'filename' for name only
		lualine_y = { "%f" },
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { "diff" },
		lualine_y = { "%f" },
		lualine_z = {},
	},
})

-- lsp
-- defaults defined at https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- local configs can be defined in ~/.config/nvim/lsp/
vim.lsp.enable({
	"basedpyright",
	"gopls",
	"lua_ls",
	"ts_ls",
})

-- fzf-lua
local fzf = require("fzf-lua")
fzf.setup({
	files = {
		hidden = true,
	},
	grep = {
		hidden = true,
	},
})
-- find files
vim.keymap.set("n", "<leader>ff", function()
	fzf.files()
end)
-- live grep
vim.keymap.set("n", "<leader>fg", function()
	fzf.live_grep_native()
end)
-- marks
vim.keymap.set("n", "<leader>fm", function()
	fzf.marks()
end)
-- buffers
vim.keymap.set("n", "<leader>fb", function()
	fzf.buffers()
end)
-- help tags
vim.keymap.set("n", "<leader>fh", function()
	fzf.helptags()
end)

-- harpoon
local harpoon = require("harpoon")
harpoon.setup({})
vim.keymap.set("n", "<leader>A", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>a", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>5", function()
	harpoon:list():select(5)
end)

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
	filters = {
		dotfiles = false,
		custom = { "^.git$" },
	},
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = true,
	view = {
		side = "right",
	},
	renderer = {
		highlight_git = "none",
		highlight_opened_files = "none",
		icons = {
			git_placement = "signcolumn",
			show = {
				file = true,
				folder = false,
				folder_arrow = true,
				git = true,
			},
		},
	},
})
local api = require("nvim-tree.api")
vim.keymap.set("n", "<leader>tt", api.tree.toggle)
vim.keymap.set("n", "<leader>tf", api.tree.focus)
vim.keymap.set("n", "<leader>tb", function()
	api.tree.find_file({ update_root = true, open = true, focus = true })
end)
vim.keymap.set("n", "<leader>tc", function()
	api.tree.collapse_all()
end)

-- Navigate left
vim.keymap.set("n", "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>")
-- Navigate down
vim.keymap.set("n", "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>")
-- Navigate up
vim.keymap.set("n", "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>")
-- Navigate right
vim.keymap.set("n", "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>")
-- Navigate previous
vim.keymap.set("n", "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>")

-- treesitter
require("nvim-treesitter.configs").setup({
	auto_install = true,
    highlight = {
      enable = true,
    },
})

-- trouble
local trouble = require("trouble")
trouble.setup({
	modes = {
		-- Diagnostics for the current buffer and errors from the current project
		mydiags = {
			mode = "diagnostics", -- inherit from diagnostics mode
			filter = {
				any = {
					buf = 0, -- current buffer
					{
						severity = vim.diagnostic.severity.ERROR, -- errors only
						-- limit to files in the current project
						function(item)
							return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
						end,
					},
				},
			},
		},
	},
})
-- Diagnostics (Trouble)
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble mydiags toggle<cr>")
-- Buffer Diagnostics (Trouble)
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
-- Symbols (Trouble)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>")
-- LSP Definitions / references / ... (Trouble)
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>")
-- Location List (Trouble)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>")
-- Quickfix list
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>")

-- toggleterm
local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end
local fish_shell = "/usr/bin/fish"
require("toggleterm").setup({
	hide_numbers = true,
	open_mapping = [[<c-\>]],
	direction = "float",
	float_opts = {
		border = "curved",
	},
	shell = file_exists(fish_shell) and fish_shell or vim.o.shell,
})
-- lazygit specific terminal open
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
-- must be global
function _lazygit_toggle()
        lazygit:toggle()
end
-- must use this nvim_set_keymap
vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true })

-- colorscheme
vim.cmd.colorscheme(colorscheme)
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "original"
