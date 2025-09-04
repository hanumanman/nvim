-- For overriding LazyVim's default plugins
local bufferline = require("bufferline")
return {
  -- Add border for blink UI
  {
    "saghen/blink.cmp",
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        style_preset = {
          bufferline.style_preset.no_italic,
        },
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = { "", "" },
      },
    },
  },
  {
    "folke/flash.nvim",
    keys = {
      { "S", false },
      {
        "<leader>o",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      indent = { -- only show indent guides of the current scope
        indent = {
          enabled = false,
          only_scope = true,
          only_current = true,
        },
      },
      dashboard = {
        preset = {
          pick = function(cmd, opts)
            return LazyVim.pick(cmd, opts)()
          end,
          header = [[
			 /|､       
			(°､ ｡ 7    
			|､  ~ヽ    
			    じしf_,)〳    ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        },
      },
    },
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { underline = true })
    end,
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "K",
        function()
          return vim.lsp.buf.hover({ border = "rounded" })
        end,
      }
    end,
  },
}
