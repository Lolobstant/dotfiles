return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "Mason",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    {
      "williamboman/mason.nvim",
      dependencies = { "williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim" },
      config = require("plugins.configs.mason"),
    }, -- NOTE: Must be loaded before dependants
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { "j-hui/fidget.nvim", opts = {} },
    -- Allows extra capabilities provided by blink.cmp
    "saghen/blink.cmp",
  },
  config = require("plugins.configs.lsp"),
  -- build = function()
  -- 	local utils = require("utils")
  -- 	vim.notify("run mason update")
  -- 	local res = pcall(vim.cmd, "MasonUpdate")
  -- 	vim.print(utils.dump(res))
  -- end,
}
