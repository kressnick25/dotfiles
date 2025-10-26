return {
    "neovim/nvim-lspconfig",
    config = function ()
        -- defaults defined at https://github.com/neovim/nvim-lspconfig/tree/master/lsp
        -- local configs can be defined in ~/.config/nvim/lsp/
        vim.lsp.enable({
            "basedpywright",
            "gopls",
            "lua_ls",
            "ts_ls",
        })
    end,
}
