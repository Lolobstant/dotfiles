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
  { "nvim-mini/mini.bufremove", version = false },
  { -- swap lines with jk keys
    "nvim-mini/mini.move",
    version = false,
    event = "VeryLazy",
    opts = require("plugins.configs.mini-move"),
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    -- build = "./kitty/install-kittens.bash",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },
  { -- nice display for TODO|INFO|WARN|... comments
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = require("plugins.configs.todo-comments"),
  },
  {
    "nvim-mini/mini.pairs",
    version = false,
    config = true,
    event = { "BufReadPre", "BufNewFile" },
  },
  { "nvim-mini/mini.surround", version = false, config = true },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre" },
    opts = require("plugins.configs.hlchunk"),
  },
  { -- statusLine
    -- TODO: replace with heirline nvim
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- event = 'VeryLazy',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = require("plugins.configs.lualine"),
  },
  -- { "nvim-mini/mini.statusline", version = false },
  { -- better keyboard mouvements
    "smoka7/hop.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    version = "v2.x",
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
  { -- file explorer
    "echasnovski/mini.files",
    event = "VeryLazy",
    version = false,
    opts = require("plugins.configs.mini-files"),
  },
  -- { -- home screen
  --   "goolord/alpha-nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = function()
  --     return require("plugins.configs.alpha")
  --   end,
  -- },
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
      { "nvim-telescope/telescope.nvim" },
      { "Shatur/neovim-session-manager" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      -- vim.g.mkdp_browser = "open" -- macOS open command
      vim.g.mkdp_browser = ""
      vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
      vim.cmd([[
      function! OpenMarkdownPreview(url)
        call jobstart(['open', a:url])
      endfunction
    ]])
    end,
  },
  -- { "shortcuts/no-neck-pain.nvim", version = "*" },
  -- {
  --   "folke/twilight.nvim",
  --   -- opts = {
  --   -- 	context = 5,
  --   -- 	dimming = {
  --   -- 		alpha = 0.55, -- amount of dimming
  --   -- 		-- we try to get the foreground from the highlight groups or fallback color
  --   -- 		-- color = { "Normal", "#ffffff" },
  --   -- 		-- term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
  --   -- 		-- inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
  --   -- 	},
  --   -- },
  --   -- configs = true,
  --   -- configs = function(_, opts)
  --   -- 	require().setup(opts)
  --   -- end,
  -- },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    config = true,
  },
  -- { 'edluffy/hologram.nvim',      opts = { auto_display = true } }
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
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = { enabled = false },
      completions = { lsp = { enabled = true } },
    },
  },
  -- {
  --   "obsidian-nvim/obsidian.nvim",
  --   version = "*", -- recommended, use latest release instead of latest commit
  --   ft = "markdown",
  --   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  --   -- event = {
  --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   --   -- refer to `:h file-pattern` for more examples
  --   --   "BufReadPre ~/notes/**/*.md",
  --   --   "BufNewFile ~/notes/**/*.md",
  --   -- },
  --   ---@module 'obsidian'
  --   ---@type obsidian.config
  --   opts = {
  --     workspaces = {
  --       {
  --         name = "my zettel",
  --         path = "~/notes/",
  --       },
  --     },
  --     templates = { folder = "templates" },
  --   },
  -- },
}
