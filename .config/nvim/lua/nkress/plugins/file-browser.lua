function configFn ()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.termguicolors = true

    local function my_on_attach(bufnr)
        local api = require 'nvim-tree.api'
        vim.keymap.set('n', '<leader>tt', api.tree.toggle) 
        vim.keymap.set('n', '<leader>tf', api.tree.focus) 
        vim.keymap.set('n', '<leader>tb', function () api.tree.find_file({ update_root = true, open = true, focus = true }) end)
        vim.keymap.set('n', '<leader>tc', function () api.tree.collapse_all() end) 
    end

    opts = {
        filters = {
            dotfiles = true,
            custom = { '^.git$' },
        
        },
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = true,
        renderer = {
            highlight_opened_files = 'all',
            icons = {
                git_placement = 'signcolumn',
                show = {
                    file = true,
                    folder = false,
                    folder_arrow = true,
                    git = true
                }
            }
        }
    }

    require('nvim-tree').setup(opts)

    -- opts.on_attach does not seem to play nice with lazy
    -- call here directly instead
    my_on_attach()
    
end

return { 
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        -- requires a nerd font
        'nvim-tree/nvim-web-devicons',
    },
    config = configFn
}
