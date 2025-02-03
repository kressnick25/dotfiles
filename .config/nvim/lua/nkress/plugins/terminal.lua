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
	end,
}
