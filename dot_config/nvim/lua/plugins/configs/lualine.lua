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
-- Couleurs par mode (style NvChad)
local mode_colors = {
  n = "#81a1c1", -- bleu    (normal)
  i = "#a3be8c", -- vert    (insert)
  v = "#b48ead", -- violet  (visual)
  V = "#b48ead",
  c = "#ebcb8b", -- jaune   (command)
  R = "#bf616a", -- rouge   (replace)
}

local function mode_color()
  return { bg = mode_colors[vim.fn.mode():sub(1, 1)] or "#81a1c1", fg = "#2e3440", gui = "bold" }
end

return {
  options = {
    icons_enabled = true,
    theme = "auto",
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
    lualine_a = { { "mode", icon = "", padding = { left = 1, right = 1 }, color = mode_color } },
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
