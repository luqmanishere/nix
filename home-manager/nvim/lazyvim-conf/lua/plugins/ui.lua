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
  { "NTBBloodbath/sweetie.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "sweetie",
    },
  },
}
