local function set_highlights(highlights, definition)
	for _, group in ipairs(highlights) do
		vim.api.nvim_set_hl(0, group, definition)
	end
end

return {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
		-- vim.o.background = "dark"
		vim.cmd.colorscheme("terafox")
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
		-- set_highlights({ "@comment", "@lsp.type.comment" }, { italic = true, fg = "#6D7F8B" })
		-- set_highlights({ "TabLineSel" }, { fg = "#d8dee9", bg = "#191d24", bold = true })
		-- set_highlights({ "TabLineFill", "TabLine" }, { fg = "#60728a", bg = "#191d24" })
	end,
}
