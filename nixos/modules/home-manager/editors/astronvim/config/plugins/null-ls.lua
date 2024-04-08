return {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function(_, opts)
		-- config variable is the default configuration table for the setup function call
		-- local null_ls = require "null-ls"

		-- Check supported formatters and linters
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		local null_ls = require("null-ls")
		opts.debug = true
		if type(opts.sources) == "table" then
			vim.list_extend(opts.sources, {
				null_ls.builtins.code_actions.statix,
				null_ls.builtins.formatting.alejandra,
				null_ls.builtins.diagnostics.deadnix,
				null_ls.builtins.formatting.stylua,
			})
		else
			opts.sources = {
				null_ls.builtins.code_actions.statix,
				null_ls.builtins.formatting.alejandra,
				null_ls.builtins.diagnostics.deadnix,
				null_ls.builtins.formatting.stylua,
			}
		end
		return opts -- return final config table
	end,
}
