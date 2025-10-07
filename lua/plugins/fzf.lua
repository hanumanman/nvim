return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-mini/mini.icons" },
	opts = {},
	keys = {
		{
			"<leader>s",
			function()
				FzfLua.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>dw",
			function()
				FzfLua.live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>do",
			function()
				FzfLua.oldfiles({ cwd_only = true })
			end,
			desc = "Search old files",
		},
		{
			"<leader>d/",
			function()
				FzfLua.blines()
			end,
			desc = "Search old files",
		},
		{
			"<leader>da",
			function()
				FzfLua.resume()
			end,
			desc = "Resume search",
		},
	},
}
