---@diagnostic disable: missing-fields
return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		dependencies = {
			{
				"windwp/nvim-ts-autotag",
				lazy = false,
				config = function()
					require("nvim-ts-autotag").setup({
						opts = {
							-- Defaults
							enable_close = true, -- Auto close tags
							enable_rename = true, -- Auto rename pairs of tags
							enable_close_on_slash = true, -- Auto close on trailing </
						},
					})
				end,
			},
			{
				"numToStr/Comment.nvim",
				opts = {},
			},
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				event = "BufRead",
				config = function()
					-- For Comment.nvim
					require("Comment").setup({
						pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
					})
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-context", -- Sticky scroll
				init = function()
					vim.cmd([[
          hi TreesitterContextBottom gui=underline guisp=Grey
          hi TreesitterContextLineNumberBottom gui=underline guisp=Grey
          ]])
				end,
				opts = {
					enable = false,
				},
				keys = {
					{
						"<leader>tc",
						"<cmd>TSContextToggle<cr>",
						desc = "Toggle treesitter context",
					},
				},
			},
		},
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = { enable = true },
		},
	},
}
