require("nkress.set")
require("nkress.remap")

-- Use Lazy for package management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('nkress/plugins', {
})

vim.opt.termguicolors = true
vim.cmd.colorscheme 'vague' -- gruvbox-material|evergarden|everforrest|onenord|vague
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_foreground = 'original'
vim.o.background = 'dark'

