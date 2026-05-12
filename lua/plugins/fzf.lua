return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-mini/mini.icons" },
	config = function()
		require("fzf-lua").setup({
			lsp = {
				code_actions = {
					trim_prompt = "Apply suggested fix: ",
					previewer = false,
				},
			},
		})
		require("fzf-lua").register_ui_select(function(fzf_opts, _)
			if fzf_opts.kind == "codeaction" then
				return vim.tbl_deep_extend("force", fzf_opts, {
					winopts = {
						height = 0.5,
						width = 0.4,
						row = 0.5,
						col = 0.5,
					},
				})
			end
			return fzf_opts
		end)

		local orig_code_action = vim.lsp.buf.code_action
		vim.lsp.buf.code_action = function(opts)
			opts = opts or {}
			opts.filter = function(action)
				local title = action.title or ""
				local is_disabled = title:match("%(disabled%)") or action.disabled
				return not is_disabled
			end
			return orig_code_action(opts)
		end
	end,
	keys = {
		{
			"<leader>s",
			function()
				FzfLua.files()
			end,
			desc = "Find files",
		},
		{
			"<leader>dw",
			function()
				FzfLua.live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<leader>do",
			function()
				FzfLua.oldfiles({ cwd_only = true })
			end,
			desc = "Search old files",
		},
		{
			"<leader>/",
			function()
				FzfLua.blines()
			end,
			desc = "Search old files",
		},
		{
			"<leader>da",
			function()
				FzfLua.resume()
			end,
			desc = "Resume search",
		},
		{
			"<leader>dh",
			function()
				FzfLua.command_history()
			end,
			desc = "Command history",
		},
	},
}
