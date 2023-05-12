return {
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},       -- Loads default behaviour
        ["core.integrations.treesitter"] = {},
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = {      -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
            name = "neorg"
          }
        }
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  }
}
