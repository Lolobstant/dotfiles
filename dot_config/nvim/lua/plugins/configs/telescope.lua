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

local actions = require("telescope.actions")
return {
  defaults = {
    path_display = { "smart" },
    file_ignore_patterns = { "node_modules" },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
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
  -- winblend = 0,
  -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  -- color_devicons = true,
  -- set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
  -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
  -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,

  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--max-depth",
        "5",
        "--prune",
        "--unrestricted",
        "--exclude",
        "node_modules",
        "--exclude",
        ".swap",
        "--exclude",
        ".git",
      },
      -- find_command = { 'rg', "--files", "--hidden", "--glob", "!{.git,node_modules}/*" }
    },
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
        },
      },
    },
    colorscheme = {
      enable_preview = true,
    },
  },
  extensions_list = { "fzf", "git_worktree", "todo-comments", "workspaces", "undo" },
  extensions = {},
}
