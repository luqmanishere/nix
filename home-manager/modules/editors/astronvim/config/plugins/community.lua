return {
	-- Add the community repository of plugin specifications
	"AstroNvim/astrocommunity",
	-- example of imporing a plugin, comment out to use it or add your own
	-- available plugins can be found at https://github.com/AstroNvim/astrocommunity

	-- { import = "astrocommunity.colorscheme.catppuccin" },
	-- { import = "astrocommunity.completion.copilot-lua-cmp" },
	--
	-- colorschemes
	{ import = "astrocommunity.colorscheme.tokyonight-nvim" },
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

	-- language packs
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.pack.rust" },
	{ import = "astrocommunity.pack.toml" },

	{ import = "astrocommunity.color.ccc-nvim" },
	{ import = "astrocommunity.color.mini-hipatterns" },

	{ import = "astrocommunity.diagnostics.lsp_lines-nvim" },

	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	-- disabled because not working
	-- { import = "astrocommunity.editing-support.ultimate-autopair-nvim" },
	{ import = "astrocommunity.editing-support.nvim-devdocs" },
	{ import = "astrocommunity.editing-support.suda-vim" },

	{ import = "astrocommunity.motion.leap-nvim" },

	{ import = "astrocommunity.scrolling.mini-animate" },
	{ import = "astrocommunity.scrolling.neoscroll-nvim" },
}
