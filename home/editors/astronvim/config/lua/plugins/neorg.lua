-- config for neorg
return {
  "nvim-neorg/neorg",
  version = "^8",
  dependencies = {
    {
      "vhyrro/luarocks.nvim",
      priority = 1000, -- We'd like this plugin to load first out of the rest
      opts = {
        luarocks_build_args = {
          -- NOTE: This path will be different for you.
          -- Find it with `nix-store --query $(which luajit)` Don't forget to add the `/include`
          "--with-lua-include=/nix/store/84wr32rvam6z14hsl0wir30r5lw7y57r-home-manager-path/include",
        },
      },
    },
  },
  event = "VeryLazy",
  opts = {
    load = {
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.keybinds"] = {}, -- Adds default keybindings
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      }, -- Enables support for completion plugins
      ["core.esupports.metagen"] = {
        config = {
          author = "luqman",
          timezone = "local",
          type = "auto",
        },
      },
      ["core.journal"] = {}, -- Enables support for the journal module
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          default_workspace = "notes",
          workspaces = {
            notes = "~/projects/notes",
          },
        },
      },
    },
  },
}
