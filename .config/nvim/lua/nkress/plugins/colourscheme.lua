return {
    {
      "neanias/everforest-nvim",
      version = false,
      lazy = false,
      priority = 1000, -- make sure to load this before all the other start plugins
      -- Optional; default configuration will be used if setup isn't called.
      config = function()
        require("everforest").setup({
          -- Your config here
        })
      end,
    },

    { 
        'crispybaccoon/evergarden',
        opts = {
            transparent_background = false,
            contrast_dark = 'hard', -- hard|medium|soft
            overrides = {}
        }
    },
    {
        'sainnhe/gruvbox-material'
    },
    { 'savq/melange-nvim' },
    { 'rmehri01/onenord.nvim' },
}
