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
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
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
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if
            client
            and client.supports_method(
              client,
              vim.lsp.protocol.Methods.textDocument_inlayHint,
              event.buf
            )
          then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
              )
            end, '[T]oggle Inlay [H]ints')
          end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				jsonls = {
					-- lazy-load schemastore when needed
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						less = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						scss = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},
			}

			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				--lsp
				"vtsls",
				"lua-language-server",
				"json-lsp",
				"css-lsp",
				"emmet-language-server",
				"eslint-lsp",
				"tailwindcss-language-server",
				"svelte-language-server",
				-- formatter
				"stylua",
				"shfmt",
				"prettierd",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			---@diagnostic disable-next-line: missing-fields
			require("mason-lspconfig").setup({
				-- ensure_installed = ensure_installed,
				-- automatic_installation = true,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"yioneko/nvim-vtsls",
		lazy = false,
		keys = {
			{
				"<leader>is",
				mode = "n",
				function()
					require("vtsls").commands.organize_imports()
				end,
				desc = "Organize imports",
			},
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
