return {
	"nvim-lualine/lualine.nvim",
	enabled = true,
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local function git_username()
			local handle = io.popen("git config user.name")
			if not handle then
				return ""
			end
			local result = handle:read("*a")
			handle:close()
			if result == "" then
				return ""
			end
			return "󰊢 " .. (result:gsub("^%s*(.-)%s*$", "%1")) -- Trim whitespace and add git icon
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				disabled_filetypes = { "neo-tree", "alpha", "trouble", "Avante", "AvanteInput" },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					{ git_username },
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_x = { "filetype" },
			},
		})
	end,
}
