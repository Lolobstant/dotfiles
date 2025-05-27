return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPre", "BufNewFile" },
	priority = 100,
	dependencies = {
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lua",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
		}, -- Required
	},
	opts = require("plugins.configs.cmp"),
	-- -- Autocompletion
	-- 'hrsh7th/nvim-cmp',
	-- dependencies = {
	--   -- Snippet Engine & its associated nvim-cmp source
	--   {
	--     'L3MON4D3/LuaSnip',
	--     config = function() vim.tbl_map(function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
	--         { "vscode", "snipmate", "lua" }) end
	--   },
	--   'saadparwaiz1/cmp_luasnip',
	--
	--   -- Adds LSP completion capabilities
	--   'hrsh7th/cmp-nvim-lsp',
	--
	--   -- Adds a number of user-friendly snippets
	--   'rafamadriz/friendly-snippets',
	--   "hrsh7th/cmp-buffer",
	--   "hrsh7th/cmp-path",
	-- },
	-- lazy = false,
	-- opts = function()
	--   local cmp = require 'cmp'
	--   local luasnip = require 'luasnip'
	--
	--   local border_opts = {
	--     border = "single",
	--     winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
	--   }
	--   require('luasnip.loaders.from_vscode').lazy_load()
	--
	--   luasnip.config.setup {}
	--   cmp.setup {
	--     snippet = {
	--       expand = function(args) luasnip.lsp_expand(args.body) end
	--     },
	--     sources = cmp.config.sources {
	--       { name = 'nvim_lsp', priority = 1000 },
	--       { name = 'luasnip',  priority = 750 },
	--       { name = 'buffer',   priority = 500 },
	--       { name = 'path',     priority = 250 },
	--     },
	--     duplicates = {
	--       nvim_lsp = 1,
	--       luasnip = 1,
	--       cmp_tabnine = 1,
	--       buffer = 1,
	--       path = 1,
	--     },
	--     window = {
	--       completion = cmp.config.window.bordered(border_opts),
	--       documentation = cmp.config.window.bordered(border_opts),
	--     },
	--     mapping = cmp.mapping.preset.insert {
	--       ['<C-n>'] = cmp.mapping.select_next_item(),
	--       ['<C-p>'] = cmp.mapping.select_prev_item(),
	--       ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
	--       ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
	--       ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
	--       ["<CR>"] = cmp.mapping.confirm { select = true },
	--       ['<Tab>'] = cmp.mapping(function(fallback)
	--         if cmp.visible() then
	--           cmp.select_next_item()
	--         elseif luasnip.expand_or_locally_jumpable() then
	--           luasnip.expand_or_jump()
	--         else
	--           fallback()
	--         end
	--       end, { 'i', 's' }),
	--       ['<S-Tab>'] = cmp.mapping(function(fallback)
	--         if cmp.visible() then
	--           cmp.select_prev_item()
	--         elseif luasnip.locally_jumpable(-1) then
	--           luasnip.jump(-1)
	--         else
	--           fallback()
	--         end
	--       end, { 'i', 's' }),
	--     }
	--   }
	-- end
}
