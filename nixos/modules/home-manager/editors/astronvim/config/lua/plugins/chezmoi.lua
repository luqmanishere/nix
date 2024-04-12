return {
  {
    "xvzc/chezmoi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "ChezmoiEdit",
    init = function()
      require("telescope").load_extension("chezmoi")
    end,
    config = function()
      require("chezmoi").setup({
        -- your configurations
        edit = {
          watch = true,
        },
      })
    end,
    keys = {
      { "<leader>tc", "<cmd>Telescope chezmoi find_files<cr>" },
    },
  },
}
