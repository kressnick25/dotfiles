return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        opts = {
           theme = 'gruvbox-material',
           sections = {
               lualine_a = {'mode'},
               lualine_b = {'branch', 'diagnostics'},
               lualine_c = {},
               lualine_x = {'encoding', 'fileformat', 'filetype'},
               lualine_y = {'progress'},
               lualine_z = {'location'}
            },
            inactive_sections = {
               lualine_a = {},
               lualine_b = {},
               lualine_c = {},
               lualine_x = {'location'},
               lualine_y = {},
               lualine_z = {}
            },
            winbar = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {},
              lualine_x = {'diff'},
              -- %f shows full file path, use 'filename' for name only
              lualine_y = {'%f'},
              lualine_z = {}
            },
            inactive_winbar = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {},
              lualine_x = {'diff'},
              lualine_y = {'%f'},
              lualine_z = {}
            }
        }
        require('lualine').setup(opts)
    end,
}
