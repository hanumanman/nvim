return {

	{
		"wnkz/monoglow.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monoglow").setup({
				on_colors = function(colors)
					colors.glow = "#007BA7"
				end,
				on_highlights = function(hl)
					hl["@function"] = { fg = "#ebebeb", italic = true, bold = true }
					hl["@lsp.type.property"] = { fg = "#ebebeb", italic = false, bold = false }
				end,
			})
			vim.cmd([[colorscheme monoglow]])
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
	{
		"Mofiqul/vscode.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			require("vscode").setup({
				group_overrides = {
					FlashBackdrop = { fg = "gray" }, -- gray
					FlashMatch = { link = "SpecialKey" },
					FlashLabel = { link = "CurSearch" },
					["@function"] = { italic = true },
					["@lsp.type.variable"] = { bold = true },
				},
			})
			vim.cmd([[colorscheme vscode]])
		end,
	},
}
