--TODO:
-- undo tree
-- DAP
-- affichage ligne buffer (active buffers, modifierd..)
-- gestion des tab (creation, navigation, session)
-- scratchpad
-- https://github.com/luckasRanarison/nvim-devdocs
-- https://github.com/nvim-neotest/neotest?tab=readme-ov-file#supported-runners
-- https://github.com/nvim-focus/focus.nvim
-- https://github.com/kawre/leetcode.nvim
-- https://github.com/zeioth/garbage-day.nvim
return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- dependencies = { "echasnovski/mini.icons", version = false },
    opts = require("plugins.configs.which-key"),
  },
  { "echasnovski/mini.bufremove", version = false },
  { -- swap lines with jk keys
    "echasnovski/mini.move",
    version = false,
    event = "VeryLazy",
    opts = require("plugins.configs.mini-move"),
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    build = "./kitty/install-kittens.bash",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },
  { -- nice display for TODO|INFO|WARN|... comments
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = require("plugins.configs.todo-comments"),
    config = true,
  },

  { -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        -- or vim.bo.commentstring,
      })
    end,
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre" },
    opts = require("plugins.configs.hlchunk"),
  },
  { -- nice ui for input & selects
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#EFF1EB",
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 1000 })
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require("plugins.configs.noice"),
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  { -- statusLine
    -- TODO: replace with heirline nvim
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- event = 'VeryLazy',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = require("plugins.configs.lualine"),
  },

  { -- better keyboard mouvements
    "smoka7/hop.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    version = "v2.x",
    config = true,
  },
  { -- better folding
    "kevinhwang91/nvim-ufo",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    config = true,
  },
  { -- show the code context
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      max_lines = 3,
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
    config = require("plugins.configs.git-worktree"),
  },
  { -- file explorer
    "echasnovski/mini.files",
    event = "VeryLazy",
    version = false,
    opts = require("plugins.configs.mini-files"),
  },
  { -- home screen
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return require("plugins.configs.alpha")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    cmd = { "ToggleTerm", "TermExec" },
    opts = require("plugins.configs.toggleterm"),
  },
  {
    "coffebar/neovim-project",
    -- event = 'VeryLazy',
    opts = {
      projects = { -- define project roots
        "~/Dev/mangas.io/*",
        "~/.config/nvim.custom",
      },
      last_session_on_startup = false,
      -- dashboard_mode = true,
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
  },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   ft = { "markdown" },
  --   build = function()
  --     vim.fn["mkdp#util#install"]()
  --   end,
  -- },
  { "shortcuts/no-neck-pain.nvim", version = "*" },
  {
    "folke/twilight.nvim",
    -- opts = {
    -- 	context = 5,
    -- 	dimming = {
    -- 		alpha = 0.55, -- amount of dimming
    -- 		-- we try to get the foreground from the highlight groups or fallback color
    -- 		-- color = { "Normal", "#ffffff" },
    -- 		-- term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
    -- 		-- inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
    -- 	},
    -- },
    -- configs = true,
    -- configs = function(_, opts)
    -- 	require().setup(opts)
    -- end,
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    config = true,
  }, -- { 'edluffy/hologram.nvim',      opts = { auto_display = true } }
  -- {
  -- 	"nvim-zh/colorful-winsep.nvim",
  -- 	config = true,
  -- 	event = { "WinNew" },
  -- },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
  },
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
    },
  },
}
-- {
--   "nvim-telescope/telescope-file-browser.nvim",
--   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
-- }
--
-- {
--   'echasnovski/mini.indentscope',
--   version = false,
--   opts = {
--     draw = {
--       delay = 50,
--     },
--     symbol = "▏",
--   },
--   configs = function(_, opts) require('mini.indentscope').setup(opts) end
-- },
-- {
--   "lukas-reineke/indent-blankline.nvim",
--   opts = {
--     pace_char_blankline = " ",
--     show_current_context_start = true,
--     show_trailing_blankline_indent = false,
--     use_treesitter = true,
--     char = "▏",
--     -- context_char = "▏",
--     show_current_context = true,
--
--   }
-- },
-- {
--   "folke/twilight.nvim",
--   opts = {
--     context = [ 5,
--     dimming = {
--       alpha = 0.55, -- amount of dimming
--       -- we try to get the foreground from the highlight groups or fallback color
--       -- color = { "Normal", "#ffffff" },
--       -- term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
--       -- inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
--     },
--   },
--   configs = function(_, opts) require().setup(opts) end
-- },
