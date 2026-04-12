return {
  -- {
  --   "SuperBo/fugit2.nvim",
  --   opts = {
  --     libgit2_path = "/opt/homebrew/lib/libgit2.dylib",
  --     width = 100,
  --   },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "chrisgrieser/nvim-tinygit", -- optional: for Github PR view
  --       dependencies = { "stevearc/dressing.nvim" },
  --     },
  --   },
  --   cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
  -- },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua", -- optional
    },
    event = "VeryLazy",
    -- lazy = true,
    cmd = "Neogit",
    opts = {
      graph_style = "unicode",
      integrations = {
        diffview = true,
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)
      -- hl.setup() lit make_palette() qui dépend du colorscheme courant.
      -- Double schedule = on est garantis APRÈS tous les ColorScheme events pending
      -- (patana UIEnter, huez auto-apply, etc.)
      vim.schedule(function()
        vim.schedule(function()
          require("neogit.lib.hl").setup(require("neogit.config").values)
        end)
      end)
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
  }, -- optional - Diff integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    cmd = "Gitsigns",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
    config = require("plugins.configs.git-worktree"),
  },

  -- {
  --   "kdheepak/lazygit.nvim",
  --   cmd = {
  --     "LazyGit",
  --     "LazyGitConfig",
  --     "LazyGitCurrentFile",
  --     "LazyGitFilter",
  --     "LazyGitFilterCurrentFile",
  --   },
  --   -- optional for floating window border decoration
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   -- setting the keybinding for LazyGit with 'keys' is recommended in
  --   -- order to load the plugin when the command is run for the first time
  --   -- keys = {
  --   --   { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  -- },
  -- {
  --   "chrisgrieser/nvim-tinygit",
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-telescope/telescope.nvim", -- optional, but recommended
  --     "rcarriga/nvim-notify", -- optional, but recommended
  --   },
  -- },
}
