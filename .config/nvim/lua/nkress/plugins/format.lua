return {
    "stevearc/conform.nvim",
    event = "BufEnter",
    opts = {
        formatters_by_ft = {
            python = { "black" },
            lua = { "stylua" },
            javascript = { "prettier" },
        },
        default_format_opts = {
            lsp_format = "fallback",
            stop_after_first = true,
        },
    },
    keys = {
        {
            "<leader>gf",
            function()
                require("conform").format()
            end,
            desc = "Format buffer",
        },
    },
}
