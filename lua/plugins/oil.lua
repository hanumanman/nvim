return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module 'oil'
	keys = {
		{
			"-",
			"<cmd>Oil --float<cr>",
			mode = "n",
			desc = "Open Oil",
		},
	},
	---@type oil.SetupOpts
	opts = {
		float = {
			padding = 7,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},
	},
}
