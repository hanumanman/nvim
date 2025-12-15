-- Global commands for Neovim

-- LSPSortImports command
-- Organize/sort imports based on the current filetype
vim.api.nvim_create_user_command("LSPSortImports", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	-- Check if LSP is attached
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		vim.notify("No LSP client attached to this buffer", vim.log.levels.WARN)
		return
	end

	-- Language-specific handlers
	local handlers = {
		python = function()
			-- Find ruff client
			local ruff_client = nil
			for _, client in ipairs(clients) do
				if client.name == "ruff" then
					ruff_client = client
					break
				end
			end

			if not ruff_client then
				vim.notify("Ruff LSP not found", vim.log.levels.WARN)
				return
			end

			ruff_client:request("workspace/executeCommand", {
				command = "ruff.applyOrganizeImports",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = 1,
					},
				},
			}, function(err, result)
				if err then
					vim.notify("Error organizing imports: " .. vim.inspect(err), vim.log.levels.ERROR)
				end
			end)
		end,

		typescript = function()
			require("vtsls").commands.organize_imports(bufnr)
		end,
	}

	-- Alias for TypeScript-like languages
	handlers.typescriptreact = handlers.typescript
	handlers.javascript = handlers.typescript
	handlers.javascriptreact = handlers.typescript

	-- Execute the appropriate handler
	local handler = handlers[ft]
	if handler then
		handler()
	else
		vim.notify("LSPSortImports not supported for filetype: " .. ft, vim.log.levels.WARN)
	end
end, {
	desc = "Sort/organize imports using LSP",
})
