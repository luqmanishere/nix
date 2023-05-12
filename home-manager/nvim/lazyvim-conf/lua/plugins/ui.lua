return {
  -- the catppuccin theme
  -- { "catppuccin/nvim", name = "catppuccin",
  --   opts = {
  --     cmp                = true,
  --     gitsigns           = true,
  --     mason              = true,
  --     mini               = true,
  --     notify             = false,
  --     nvimtree           = true,
  --     symbols_outline    = true,
  --     telescope          = true,
  --     treesitter         = true,
  --     treesitter_context = true,
  --     which_key          = true,
  --   }
  -- },
  -- { "NTBBloodbath/sweetie.nvim" },

  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark",   -- style for floating windows
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
