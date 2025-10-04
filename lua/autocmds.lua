-- Highlight when yanking (copying) text
local textYankPostGroup = vim.api.nvim_create_augroup("yankTextGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = textYankPostGroup,
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

-- Set approproate filetype for JSON and .env files (for syntax highlighting and commenting mostly)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.json", ".env.*" },
	callback = function(event)
		if event.match:match("%.json$") then
			vim.bo.filetype = "jsonc"
		elseif event.match:match("%.env%..*$") then
			vim.bo.filetype = "sh"
		end
	end,
})

-- Relative line number in normal mode and absolute in insert mode
local toggleNumberGroup = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = toggleNumberGroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = toggleNumberGroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			vim.cmd("redraw")
		end
	end,
})
