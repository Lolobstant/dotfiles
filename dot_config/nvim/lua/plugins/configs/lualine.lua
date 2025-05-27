-- local C = require("catppuccin.palettes").get_palette()
-- local config = {
--   left_separator = "",
--   right_separator = "",
--   mode_icon = "",
--   dir = "󰉖",
--   file = "󰈙",
--   lsp = {
--     icons = {
--       formatter = "󰛿",
--       linter = "󰸥",
--       server = "󰅡",
--       error = "",
--       warning = "",
--       info = "",
--       hint = "",
--     },
--     exclude = {},
--     server_to_name_map = {},
--     update_in_insert = false,
--   },
--   git = {
--     branch = "",
--     added = "",
--     changed = "",
--     removed = "",
--   },
-- }
-- return {
--
-- };
return {
  options = {
    icons_enabled = true,
    -- theme = "base16",
    -- component_separators = { left = "", right = "" },
    component_separators = { left = "∕", right = "⢸" },
    -- section_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { { "mode", icon = "" } },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
    lualine_y = { --[[ 'tabs', ]]
      "progress",
    },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
}
