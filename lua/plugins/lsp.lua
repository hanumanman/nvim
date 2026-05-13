return {

	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"b0o/SchemaStore.nvim",
				version = false, -- last release is way too old
			},
			"saghen/blink.cmp",
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
          -- stylua: ignore start
          map('K', function() vim.lsp.buf.hover({border = 'rounded'})  end, 'Show LSP info')
          map('<leader>e', function() vim.diagnostic.open_float { border = 'rounded' } end, 'Show full diagnostic')
          map('<leader>q', function() FzfLua.diagnostics_document() end, 'Show LSP diagnostic')
          map('gd', function() FzfLua.lsp_definitions() end, '[G]oto [D]efinition')
          map('gr', function() FzfLua.lsp_references() end, '[G]oto [R]eferences')
          map('<leader>D', function() FzfLua.lsp_typedefs() end, 'Type Definition')
          map("<leader>ds", function() FzfLua.lsp_document_symbols() end, "Find LSP document symbols")
          map('<leader>r', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
				end,
			})

			-- Apply blink.cmp capabilities to all servers
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						autoUseWorkspaceTsdk = true,
					},
					javascript = {
						preferences = {
							importModuleSpecifier = "non-relative",
						},
					},
					typescript = {
						preferences = {
							importModuleSpecifier = "non-relative",
						},
						suggest = {
							includeCompletionsForImportStatements = true,
						},
					},
				},
			})

			vim.lsp.config("ruff", {
				init_options = {
					settings = {
						organizeImports = true,
						logLevel = "debug",
					},
				},
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						format = { enable = true },
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			vim.lsp.config("cssls", {
				settings = {
					css = { validate = true, lint = { unknownAtRules = "ignore" } },
					less = { validate = true, lint = { unknownAtRules = "ignore" } },
					scss = { validate = true, lint = { unknownAtRules = "ignore" } },
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					-- lsp
					"vtsls",
					"lua-language-server",
					"json-lsp",
					"css-lsp",
					"emmet-language-server",
					"eslint-lsp",
					"tailwindcss-language-server",
					"svelte-language-server",
					"pyrefly",
					-- formatter
					"ruff",
					"stylua",
					"shfmt",
					"prettierd",
				},
			})

			require("mason-lspconfig").setup()
		end,
	},
	{
		"yioneko/nvim-vtsls",
		lazy = false,
		keys = {
			{
				"<leader>ia",
				mode = "n",
				function()
					require("vtsls").commands.add_missing_imports()
				end,
				desc = "Add all missing imports",
			},
		},
	},
}
