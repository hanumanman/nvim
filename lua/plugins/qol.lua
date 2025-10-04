return {
	-- Notify
	{ "j-hui/fidget.nvim", lazy = false, opts = {} },
	-- Underline current word
	{ "nvim-mini/mini.cursorword", version = "*", opts = {} },
	-- Add more textobject
	{ "nvim-mini/mini.ai", version = "*", opts = { n_lines = 500 } },
	-- Show appropriate buffer after one is removed
	{ "nvim-mini/mini.bufremove", version = "*", opts = {} },
	-- Show indent for current scope
	{ "nvim-mini/mini.indentscope", version = "*", opts = {} },
	-- Surround functionality
	{ "kylechui/nvim-surround", version = "^3.0.0", event = "VeryLazy", opts = {} },
	-- Hint for keymaps, register, marks,...
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { preset = "helix" },
	},
	-- Visual hint for colors
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			user_default_options = {
				tailwind = true,
				mode = "virtualtext",
			},
		},
	},
}
