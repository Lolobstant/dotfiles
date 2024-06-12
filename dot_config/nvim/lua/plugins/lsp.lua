return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		-- {
		-- 	"williamboman/mason.nvim",
		-- 	build = function()
		-- 		print("here")
		-- 		pcall(vim.cmd, "MasonUpdate")
		-- 	end,
		-- }, -- Optional
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		{ "folke/neodev.nvim", opts = {} },
	},
	config = require("plugins.configs.lsp"),
	-- build = function()
	-- 	local utils = require("utils")
	-- 	vim.notify("run mason update")
	-- 	local res = pcall(vim.cmd, "MasonUpdate")
	-- 	vim.print(utils.dump(res))
	-- end,
}
-- return  {
--
--   -- -- LSP Configuration & Plugins
--   -- 'neovim/nvim-lspconfig',
--   -- dependencies = {
--   --   -- Automatically install LSPs to stdpath for neovim
--   --   { 'williamboman/mason.nvim', config = true },
--   --   'williamboman/mason-lspconfig.nvim',
--   --
--   --   -- Useful status updates for LSP
--   --   -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--   --   { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
--   --
--   --   -- Additional lua configuration, makes nvim stuff amazing!
--   --   'folke/neodev.nvim',
--   -- },
--   -- config = require "plugins.configs.mason-lsp"
--   'VonHeikemen/lsp-zero.nvim',
--   branch = 'v2.x',
--   -- event = { 'BufReadPre', 'BufNewFile' },
--   event = 'VeryLazy',
--   cmd = 'Mason',
--   dependencies = {
--     -- NOTE: LSP Support
--     { 'neovim/nvim-lspconfig' }, -- Required
--     {
--       'williamboman/mason.nvim',
--       build = function()
--         pcall(vim.cmd, "MasonUpdate")
--       end
--     },                                       -- Optional
--     { 'williamboman/mason-lspconfig.nvim' }, -- Optional
--     { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
--
--     -- NOTE: Useful status updates for LSP
--     {
--       'j-hui/fidget.nvim',
--       tag = 'legacy',
--       opts = {}
--     },
--     -- {
--     --   "glepnir/lspsaga.nvim",
--     --   branch = "main",
--     --   requires = {
--     --     { "nvim-tree/nvim-web-devicons" },
--     --     { "nvim-treesitter/nvim-treesitter" },
--     --   },
--     -- },
--     -- NOTE: Autocompletion
--     -- { 'hrsh7th/nvim-cmp' },         -- Required
--     -- { 'hrsh7th/cmp-nvim-lsp' },     -- Required
--     -- { 'hrsh7th/cmp-buffer' },       -- Optional
--     -- { 'hrsh7th/cmp-path' },         -- Optional
--     -- { 'saadparwaiz1/cmp_luasnip' }, -- Optional
--     -- { 'hrsh7th/cmp-nvim-lua' },     -- Optional
--     -- { 'folke/neodev.nvim' },        -- Optional nvim function signature,help,completions
--
--     -- NOTE: Snippets
--     -- { 'L3MON4D3/LuaSnip' },             -- Required
--     -- { 'rafamadriz/friendly-snippets' }, -- Optional
--
--     -- NOTE: Auto-format
--     { 'lukas-reineke/lsp-format.nvim' }, -- Optional
--   },
--   config = require "plugins.configs.lsp"
-- }
