local function set_highlights(highlights, definition)
	for _, group in ipairs(highlights) do
		vim.api.nvim_set_hl(0, group, definition)
		break
	end
end

return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("kanagawa").setup({
				compile = true,
				functionStyle = { italic = true },
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors)
					local theme = colors.theme
					local makeDiagnosticColor = function(color)
						local c = require("kanagawa.lib.color")
						return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
					end

					return {
						DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
						DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
						DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
						DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
						Pmenu = { bg = "none" }, -- add `blend = vim.o.pumblend` to enable transparency
						BlinkCmpMenu = { bg = "none" },
						StatusLine = { bg = "none" },
						Float = { bg = "none" },
						NormalFloat = { bg = "none" },
						FloatTitle = { bg = "none" },
						FloatBorder = { bg = "none" },
						BlinkCmpBorder = { bg = "none" },
						BlinkCmpMenuBorder = { bg = "none" },
						LspReferenceText = { bg = "none" },
						BlinkCmpDoc = { bg = "none" },
						BlinkCmpDocBorder = { bg = "none" },
						PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p2 },
						["@lsp.type.variable"] = { bold = true },
					}
				end,
			})

			vim.cmd([[colorscheme kanagawa]])
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		-- DISABLED
		enabled = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.cmd([[colorscheme gruvbox]])

			set_highlights({ "@lsp.type.variable" }, { bold = true })
			set_highlights({
				"BlinkCmpMenu",
				"StatusLine",
				"Pmenu",
				"Float",
				"NormalFloat",
				"FloatBorder",
				"LspReferenceText",
				"BlinkCmpDoc",
				"BlinkCmpDocBorder",
			}, { bg = "none" })
			set_highlights(
				{ "LspSignatureActiveParameter", "FlashMatch" },
				{ italic = true, fg = "#ff8349", underline = true, bold = true }
			)
			set_highlights({
				"@lsp.type.method",
				"@lsp.type.function",
				"@lsp.typemod.function",
				"@function.member",
				"@function.call",
			}, { italic = true })
			set_highlights({ "@comment", "@lsp.type.comment" }, { italic = true, fg = "#6D7F8B" })
		end,
		opts = {},
	},
}
