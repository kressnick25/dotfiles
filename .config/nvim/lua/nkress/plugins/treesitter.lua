return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["<leader>nf"] = "@function.outer",
                            ["<leader>nc"] = { query = "@class.outer", desc = "next class start" },
                        },
                        goto_previous_start = {
                            ["<leader>pf"] = "@function.outer",
                            ["<leader>pc"] = { query = "@class.outer", desc = "next class start" },
                        },
                        goto_next = {
                            ["<leader>nn"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["<leader>pp"] = "@conditional.outer",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dc"] = "@class.outer",
                        }

                    }
                },
            })
        end,
    },
}
