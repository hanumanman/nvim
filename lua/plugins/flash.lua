return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader><leader>",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			"Flash Treesitter node",
		},
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
	},
}
