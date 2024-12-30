local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local shell = vim.o.shell
if (file_exists('/usr/bin/fish'))
then
    shell = '/usr/bin/fish'
end

return {
	"akinsho/toggleterm.nvim",
	tag = "v2.10.0",
	config = function()
		require("toggleterm").setup({
			hide_numbers = true,
			open_mapping = [[<c-\>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
            shell = shell,
		})

		-- lazygit specific terminal open
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
		function _lazygit_toggle()
			lazygit:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true })
	end,
}
