return {
	-- Add the community repository of plugin specifications
	"AstroNvim/astrocommunity",
	-- example of imporing a plugin, comment out to use it or add your own
	-- available plugins can be found at https://github.com/AstroNvim/astrocommunity

	-- { import = "astrocommunity.colorscheme.catppuccin" },
	-- { import = "astrocommunity.completion.copilot-lua-cmp" },
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.toml" },

	{
		"tokyonight.nvim",
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
				floats = "dark", -- style for floating windows
			},
		},
	},
}
