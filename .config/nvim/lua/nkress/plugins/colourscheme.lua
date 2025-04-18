return {
    {
        "neanias/everforest-nvim",
        event = "VeryLazy",
        version = false,
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                -- Your config here
            })
        end,
    },

    {
        'crispybaccoon/evergarden',
        event = "VeryLazy",
        opts = {
            transparent_background = false,
            contrast_dark = 'hard', -- hard|medium|soft
            overrides = {}
        }
    },
    {
        'sainnhe/gruvbox-material'
    },
    {
        'savq/melange-nvim',
        event = "VeryLazy",
    },
    {
        'rmehri01/onenord.nvim',
        event = "VeryLazy",

    },
    { "bakageddy/alduin.nvim", priority = 1000, config = true, }
}
