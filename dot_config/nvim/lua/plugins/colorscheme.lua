-- local colorschemes = vim.api.nvim_command_output('echo getcompletion("", "color")')
-- local colorschemesTable = {}
-- local patterns = { "'", " ", "%[", "%]" }
--
-- for i, v in ipairs(patterns) do
--   colorschemes = string.gsub(colorschemes, v, "")
-- end
-- colorschemes = 'gruvbox,ayu,' .. colorschemes
-- for color in string.gmatch(colorschemes, '([^,]+)') do
--   table.insert(colorschemesTable, color)
-- end
-- print('result =' .. colorschemes)
return {
  {
    "catppuccin/nvim",
    as = "catppuccin",
    opts = require 'plugins.configs.catppuccin',
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = require 'plugins.configs.rose-pine',
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      dimInactive = true, -- dim inactive window `:h hl-NormalNC`
    }
  },
  {
    dir = 'lua/my_persist_colorscheme',
    lazy = false,
    priority = 900,
    init = function()
      require('my_persist_colorscheme').setup()
    end
  },
  -- {
  --   'zaldih/themery.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     themes = colorschemesTable,
  --     themeConfigFile = "~/.config/nvim.custom/lua/config/theme.lua",
  --     livePreview = true
  --   }
  -- },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "rose-pine",
  --   },
  -- },
}
