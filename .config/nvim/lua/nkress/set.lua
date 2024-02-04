vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- enable system clipboard
-- it appears that in this mode 'p' can pastes from system,
-- but yank and delete in vim do not copy to system keyboard.
-- This seems like a good option
vim.opt.clipboard = 'unnamed'

vim.opt.ignorecase = true

-- DISABLED -- handled by lualine
-- show filename for each split, also display if modified
--vim.opt.winbar = '%=%m %f'
