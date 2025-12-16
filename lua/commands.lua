-- Global commands for Neovim

-- LSPSortImports implementation
-- Organize/sort imports based on the current filetype
-- @param callback Optional callback function to call after completion (or error)
local function lsp_sort_imports(callback)
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	-- Check if LSP is attached
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		vim.notify("No LSP client attached to this buffer", vim.log.levels.WARN)
		if callback then
			callback()
		end
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
				if callback then
					callback()
				end
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
				if callback then
					callback()
				end
			end)
		end,

		typescript = function()
			require("vtsls").commands.organize_imports(
				bufnr,
				function() -- on_resolve
					if callback then
						callback()
					end
				end,
				function(err) -- on_reject
					vim.notify("Error organizing imports: " .. vim.inspect(err), vim.log.levels.ERROR)
					if callback then
						callback()
					end
				end
			)
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
		vim.notify("LSPSortImports not supported for filetype: " .. ft, vim.log.levels.INFO)
		if callback then
			callback()
		end
	end
end

-- Expose the function globally for use in keymaps
_G.lsp_sort_imports = lsp_sort_imports

-- User command for CLI usage
vim.api.nvim_create_user_command("LSPSortImports", function()
	lsp_sort_imports()
end, {
	desc = "Sort/organize imports using LSP",
})
