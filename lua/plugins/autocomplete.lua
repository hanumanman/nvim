return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
							-- Load custom snippets
							require("snippets")
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				accept = { auto_brackets = { enabled = false } },
				menu = {
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					window = {
						border = "rounded",
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev", "buffer" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true, window = { border = "rounded" } },
		},
	},

	{
		{
			"supermaven-inc/supermaven-nvim",
			config = function()
				require("supermaven-nvim").setup({
					color = {
						suggestion_color = "#8B949E",
						cterm = 244,
					},
					keymaps = {
						accept_suggestion = "<C-l>",
						accept_word = "<C-j>",
					},
				})
			end,
		},
	},
}
