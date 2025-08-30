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
      "vague2k/vague.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other plugins
      config = function()
        -- NOTE: you do not need to call setup if you don't want to.
        require("vague").setup({
          -- optional configuration here
        })
      end
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
