return {
	"nvim-telescope/telescope.nvim",
	-- tag = '0.1.6',
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Telescope find files",
		},
		{
			"<leader>fm",
			function()
				require("telescope.builtin").marks()
			end,
			desc = "Telescope find files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Telescope live grep",
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Telescope buffers",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Telescope help tags",
		},
	},
	config = function()
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")

		local Layout = require("nui.layout")
		local Popup = require("nui.popup")
		local TSLayout = require("telescope.pickers.layout")

		local function make_popup(options)
			local popup = Popup(options)
			function popup.border:change_title(title)
				popup.border.set_text(popup.border, "top", title)
			end

			return TSLayout.Window(popup)
		end

		-- Clone the default Telescope configuration
		local vimgrep_arguments = { table.unpack(telescopeConfig.values.vimgrep_arguments) }
		--
		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")
		table.insert(vimgrep_arguments, "!**/node_modules/*")

		telescope.setup({
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
				path_display = {
					filename_first = {
						reverse_directories = false,
					},
				},
				layout_strategy = "flex",
				layout_config = {
					horizontal = {
						size = {
							width = "90%",
							height = "60%",
						},
					},
					vertical = {
						size = {
							width = "90%",
							height = "90%",
						},
					},
				},
				create_layout = function(picker)
					local border = {
						results = {
							top_left = "│",
							top_right = "│",
							top = "─",
							right = "│",
							bottom_right = "┘",
							bottom = "─",
							bottom_left = "└",
							left = "│",
						},
						results_patch = {
							minimal = {
								top_left = "┌",
								top_right = "┐",
							},
							horizontal = {
								top = "",
								bottom_right = "┴",
							},
							vertical = {
                                top = ""
							},
						},
						prompt = {
							top_left = "┌",
							top = "─",
							top_right = "┐",
							right = "│",
							bottom_right = "│",
							bottom = "",
							bottom_left = "",
							left = "│",
						},
						prompt_patch = {
							minimal = {
								bottom_right = "┘",
							},
							horizontal = {
								top_right = "┬",
							},
							vertical = {
								bottom_right = "│",
							},
						},
						preview = {
							top_left = "┌",
							top = "─",
							top_right = "┐",
							right = "│",
							bottom_right = "┘",
							bottom = "─",
							bottom_left = "└",
							left = "│",
						},
						preview_patch = {
							minimal = {},
							horizontal = {
								bottom = "─",
								bottom_left = "",
								bottom_right = "┘",
								left = "",
								top_left = "",
							},
							vertical = {
								bottom = "─",
								bottom_left = "└",
								bottom_right = "┘",
								left = "│",
								top_left = "┌",
							},
						},
					}

					local results = make_popup({
						focusable = false,
						border = {
							style = border.results,
							text = {
								top = "",
								top_align = "center",
							},
						},
						win_options = {
							winhighlight = "Normal:Normal",
						},
					})

					local prompt = make_popup({
						enter = true,
						border = {
							style = border.prompt,
							text = {
								top = picker.prompt_title,
								top_align = "center",
							},
						},
						win_options = {
							winhighlight = "Normal:Normal",
						},
					})

					local preview = make_popup({
						focusable = false,
						border = {
							style = border.preview,
							text = {
								top = "",
								top_align = "center",
							},
						},
					})

					local box_by_kind = {
						vertical = Layout.Box({
							Layout.Box(preview, { grow = 2 }),
							Layout.Box(prompt, { size = 3 }),
							Layout.Box(results, { grow = 1 }),
						}, { dir = "col" }),
						horizontal = Layout.Box({
							Layout.Box({
								Layout.Box(prompt, { size = 3 }),
								Layout.Box(results, { grow = 1 }),
							}, { dir = "col", size = "40%" }),
							Layout.Box(preview, { size = "60%" }),
						}, { dir = "row" }),
						minimal = Layout.Box({
							Layout.Box(prompt, { size = 3 }),
							Layout.Box(results, { grow = 1 }),
						}, { dir = "col" }),
					}

					local function get_box()
						local strategy = picker.layout_strategy
						if strategy == "vertical" or strategy == "horizontal" then
							return box_by_kind[strategy], strategy
						end

						local height, width = vim.o.lines, vim.o.columns
						local box_kind = "horizontal"
						if width < 150 then
							box_kind = "vertical"
							if height < 40 then
								box_kind = "minimal"
							end
						end
						return box_by_kind[box_kind], box_kind
					end

					local function prepare_layout_parts(layout, box_type)
						layout.results = results
						results.border:set_style(border.results_patch[box_type])

						layout.prompt = prompt
						prompt.border:set_style(border.prompt_patch[box_type])

						if box_type == "minimal" then
							layout.preview = nil
						else
							layout.preview = preview
							preview.border:set_style(border.preview_patch[box_type])
						end
					end

					local function get_layout_size(box_kind)
						return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
					end

					local box, box_kind = get_box()
					local layout = Layout({
						relative = "editor",
						position = "50%",
						size = get_layout_size(box_kind),
					}, box)

					layout.picker = picker
					prepare_layout_parts(layout, box_kind)

					local layout_update = layout.update
					function layout:update()
						local box, box_kind = get_box()
						prepare_layout_parts(layout, box_kind)
						layout_update(self, { size = get_layout_size(box_kind) }, box)
					end

					return TSLayout(layout)
				end,
			},
			pickers = {
                
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					sorting_strategy = "ascending",
				},
                live_grep = {
					sorting_strategy = "ascending",
                },
                buffers = {
					sorting_strategy = "ascending",
                },
                help_tags = {
					sorting_strategy = "ascending",
                },
                marks = {
					sorting_strategy = "ascending",
                },
			},
		})
	end,
}
