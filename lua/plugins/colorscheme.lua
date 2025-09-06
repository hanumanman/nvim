return {
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = false,
        styles = {
          comments = "italic",
          constants = "bold",
          functions = "italic",
        },
      },
      groups = {
        all = {
          SnacksPickerDir = { fg = "#8B949E" },
          Pmenu = { bg = "none" },
          FloatBorder = { link = "NormalFloat" },
          LspReferenceText = { bg = "none" },
          BlinkCmpMenu = { bg = "none" },
          BlinkCmpDoc = { bg = "none" },
          BlinkCmpDocBorder = { bg = "none" },
          LspSignatureActiveParameter = { link = "@string.special.url" },
        },
      },
    },
  },
  {
    -- Configure LazyVim to load colorscheme
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "duskfox",
    },
  },
}
