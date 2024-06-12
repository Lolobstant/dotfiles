-- local utils = require('utils')
-- local is_available = utils.is_available

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    -- lazy = true,
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-treesitter/nvim-treesitter",
      { 'nvim-telescope/telescope-fzf-native.nvim', enabled = vim.fn.executable "make" == 1, build = "make" }
    },
    cmd = "Telescope",
    -- init = function()
    --   require("core.utils").load_mappings "telescope"
    -- end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      -- dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        pcall(telescope.load_extension, ext)
      end
    end,
  },
  -- {
  --   'nvim-telescope/telescope.nvim',
  --   branch = '0.1.x',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  --     -- Only load if `make` is available. Make sure you have the system
  --     -- requirements installed.
  --     { 'nvim-telescope/telescope-fzf-native.nvim', enabled = vim.fn.executable "make" == 1, build = "make" }
  --   },
  --   opts = function()
  --     if is_available('telescope-file-browser.nvim') then
  --       local fb_actions = require "telescope._extensions.file_browser.actions"
  --       return {
  --         extensions = {
  --           file_browser = {
  --             theme = "dropdown",
  --             winblend = 10,
  --             layout_config = {
  --               height = 0.6,
  --               width = 0.5,
  --               bottom_pane = {
  --                 height = 0.25
  --               }
  --             },
  --             -- disables netrw(nvim native explorer i.a :Explore) and use telescope-file-browser in its place
  --             hijack_netrw = true,
  --             hidden = { file_browser = true, folder_browser = false },
  --             respect_gitignore = false,
  --             --grouped = true,
  --             auto_depth = true,
  --           }
  --         },
  --       }
  --     end
  --     return {
  --       defaults = {
  --         path_display = { "smart" },
  --         file_ignore_patterns = { "node_modules" },
  --         color_devicons = true,
  --         set_env = { ["COLORTERM"] = "truecolor" },
  --         vimgrep_arguments = {
  --           "rg",
  --           "-L",
  --           "--color=never",
  --           "--no-heading",
  --           "--with-filename",
  --           "--line-number",
  --           "--column",
  --           "--smart-case",
  --         },
  --       },
  --       pickers = {
  --         find_files = {
  --           find_command = { "fd", "--type", "f", "--strip-cwd-prefix", '--max-depth', '5', '--prune',
  --             '--unrestricted',
  --             "--exclude", 'node_modules' }
  --         },
  --         buffers = {
  --           sort_lastused = true
  --         },
  --         colorscheme = {
  --           enable_preview = true,
  --         }
  --       }
  --     }
  --   end,
  --   config = require "plugins.configs.telescope",
  -- },
}
