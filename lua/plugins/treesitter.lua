return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- Define install directory and add to runtimepath
			local install_dir = vim.fn.stdpath("data") .. "/site"
			vim.opt.runtimepath:prepend(install_dir)

			-- Setup nvim-treesitter
			require("nvim-treesitter").setup({
				install_dir = install_dir,
			})

			-- Install parsers you need
			local parsers = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "html", "css" }
			require("nvim-treesitter").install(parsers)

			-- Enable treesitter highlighting only when parser exists
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Get language from filetype
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then
						return
					end

					-- Check if parser exists before starting
					if vim.treesitter.language.add(lang) then
						vim.treesitter.start()
					end
				end,
			})
		end,
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
	},
}
