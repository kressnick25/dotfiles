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
                    select = {
                        enable = true,
                        lookahead = true,

                        keymaps = {
                            ["ai"] = { query = "@conditional.outer", desc = "Select conditional outer"},
                            ["ii"] = { query = "@conditional.inner", desc = "Select conditional inner"},

                            ["al"] = { query = "@loop.outer", desc = "Select loop outer"},
                            ["il"] = { query = "@loop.inner", desc = "Select loop inner"},

                            ["af"] = { query = "@function.outer", desc = "Select function outer"},
                            ["if"] = { query = "@function.inner", desc = "Select function inner"},

                            ["ac"] = { query = "@class.outer", desc = "Select class outer"},
                            ["ic"] = { query = "@class.inner", desc = "Select class inner"},
                        },
                    },
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
