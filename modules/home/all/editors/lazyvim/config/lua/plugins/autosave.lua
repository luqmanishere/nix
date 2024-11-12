return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      execution_message = { enabled = false },
      debounce_delay = 3000,
      -- your config goes here
      -- or just leave it empty :)
    },
  },
}
