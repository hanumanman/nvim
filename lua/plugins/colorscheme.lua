local function set_hl(name, style)
	vim.api.nvim_set_hl(0, name, style)
end

return {
	{
		"silentium-theme/silentium.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("silentium").setup({
				accent = "#007BA7",
			})
			vim.cmd([[colorscheme silentium]])
			set_hl("LspSignatureActiveParameter", { fg = "#007BA7" })
			set_hl("MiniTablineHidden", { bg = "#141414", fg = "#404040" })
			set_hl("Pmenu", { bg = "none" }) -- add `blend = vim.o.pumblend` to enable transparency
			set_hl("BlinkCmpMenu", { bg = "none" })
			set_hl("StatusLine", { bg = "none" })
			set_hl("Float", { bg = "none" })
			set_hl("NormalFloat", { bg = "none" })
			set_hl("FloatTitle", { bg = "none" })
			set_hl("FloatBorder", { bg = "none" })
			set_hl("BlinkCmpBorder", { bg = "none" })
			set_hl("BlinkCmpMenuBorder", { bg = "none" })
			set_hl("LspReferenceText", { bg = "none" })
			set_hl("BlinkCmpDoc", { bg = "none" })
			set_hl("BlinkCmpDocBorder", { bg = "none" })
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		enabled = false,
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
}
