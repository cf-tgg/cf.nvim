return {
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		lazy = false,
		priority = 100,
		dependencies = {
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"rafamadriz/friendly-snippets",
			-- Snippet Engine & its associated nvim-cmp source
			{ 'L3MON4D3/LuaSnip', build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require "custom.completion"
		end,
	},
}
