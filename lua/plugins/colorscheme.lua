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
          Snacks,
        },
      },
      groups = {
        all = {
          SnacksPickerDir = { fg = "#8B949E" },
          Pmenu = { bg = "none" },
          -- Float = { bg = "none" },
          -- NormalFloat = { bg = "none" },
          FloatBorder = { link = "NormalFloat" },
          LspReferenceText = { bg = "none" },
          BlinkCmpMenu = { bg = "none" },
          BlinkCmpDoc = { bg = "none" },
          BlinkCmpDocBorder = { bg = "none" },
        },
      },
    },
  },
  {
    -- Configure LazyVim to load colorscheme
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "terafox",
    },
  },
}
