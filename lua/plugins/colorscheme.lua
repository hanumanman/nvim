local function set_hl(name, style)
	vim.api.nvim_set_hl(0, name, style)
end

return {
	{
		"sage",
		lazy = false,
		priority = 1000,
		dir = vim.fn.stdpath("config") .. "/lua/plugins/sage",
		config = function()
			require("sage")
			set_hl("Pmenu", { bg = "none" })
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
}
