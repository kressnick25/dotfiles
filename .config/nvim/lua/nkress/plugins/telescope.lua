return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys = {
        {
            "<leader>ff",
            function()
                require("fzf-lua").files()
            end,
            desc = "Find files",
        },
        {
            "<leader>fg",
            function()
                require("fzf-lua").live_grep_native()
            end,
            desc = "Live grep",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "Buffers",
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "Help tags",
        },
    },
}
