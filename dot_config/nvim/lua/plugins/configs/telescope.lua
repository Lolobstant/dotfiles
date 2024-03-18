-- return function(_, opts)
--   local telescope = require "telescope"
--
--   telescope.setup(opts)
--   --  local utils = require "astronvim.utils"
--   --  local conditional_func = utils.conditional_func
--   --  conditional_func(telescope.load_extension, pcall(require, "notify"), "notify")
--   --  conditional_func(telescope.load_extension, pcall(require, "aerial"), "aerial")
--   --  conditional_func(telescope.load_extension, utils.is_available "telescope-fzf-native.nvim", "fzf")
--   pcall(telescope.load_extension, 'fzf')
--   pcall(telescope.load_extension, 'file_browser')
--   pcall(telescope.load_extension, 'git_worktree')
--   pcall(telescope.load_extension, 'todo-comments')
--   pcall(telescope.load_extension, 'workspaces')
--   pcall(telescope.load_extension, 'projections')
-- end

return {
  defaults = {
    path_display = { "smart" },
    file_ignore_patterns = { "node_modules" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" },
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        '--max-depth',
        '5',
        '--prune',
        '--unrestricted',
        "--exclude", 'node_modules'
      }
      -- find_command = { 'rg', "--files", "--hidden", "--glob", "!{.git,node_modules}/*" }
    },
    buffers = {
      sort_lastused = true
    },
    colorscheme = {
      enable_preview = true,
    }
  },
  extensions_list = { 'fzf', 'git_worktree', 'todo-comments', 'workspaces' }
}
