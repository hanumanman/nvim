return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 5000,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			markdown = { "prettierd" },
			json = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			sh = { "shfmt" },
		},
	},
}
