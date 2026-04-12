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
    "vague2k/huez.nvim",
    -- if you want registry related features, uncomment this

    lazy = true,
    branch = "stable",
    event = "UIEnter",
    import = "huez-manager.import",
    config = function()
      require("huez").setup({})
    end,
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
    -- lazy = true,
    opts = require("plugins.configs.catppuccin"),
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    -- lazy = true,
    opts = require("plugins.configs.rose-pine"),
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },
  {
    "nyoom-engineering/oxocarbon", --[[ lazy = true  ]]
  },
  {
    "jacoborus/tender.vim", --[[ lazy = true  ]]
  },
  {
    "savq/melange-nvim", --[[ lazy = true  ]]
  },
  {
    "cvigilv/patana.nvim", --[[ lazy = true  ]]
    priority = 1000,
    lazy = false,
    -- config = function()
    --   local function apply()
    --     vim.cmd.colorscheme("patana")
    --     vim.api.nvim_set_hl(0, "Constant", { fg = "#ff5858" })
    --   end
    --   apply()
    --   vim.api.nvim_create_autocmd("UIEnter", {
    --     once = true,
    --     callback = apply,
    --   })
    -- end,
  },
  {
    "andreasvc/vim-256noir", --[[ lazy = true  ]]
  },
  {
    "aliqyan-21/darkvoid.nvim", --[[ lazy = true  ]]
  },
  { "embark-theme/vim" },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = true,
    -- you can set set configuration options here
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    "mcauley-penney/techbase.nvim",
  },
  -- {
  --   "mitch1000/backpack",
  --   config = function()
  --     require("backpack").setup({
  --       theme = "light",
  --       contrast = "extreme",
  --     })
  --   end,
  -- },
  -- {
  -- 	dir = "/lua/themes/simplered",
  -- 	lazy = false,
  -- },
  -- {
  -- 	"rebelot/kanagawa.nvim",
  -- 	opts = {
  -- 		dimInactive = true, -- dim inactive window `:h hl-NormalNC`
  -- 	},
  -- },
  -- {
  --   dir = 'lua/my_persist_colorscheme',
  --   lazy = false,
  --   priority = 900,
  --   init = function()
  --     require('my_persist_colorscheme').setup()
  --   end
  -- },
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
