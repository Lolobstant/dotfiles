local dashboard = require('alpha.themes.dashboard')
local startup_time = nil

local function footer()
  local total_plugins = #vim.tbl_keys(require('lazy').plugins())
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local startup = not startup_time and '' or string.format('Loaded in %.oms', startup_time)

  return datetime .. "   " .. total_plugins .. " plugins " .. startup .. nvim_version_info
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup('get_startuptime', {}),
  pattern = "LazyVimStarted",
  callback = function()
    startup_time = require("lazy").stats().startuptime
    vim.cmd.AlphaRedraw()
  end,
})

local ghost = {
  "            ██████            ",
  "        ████▒▒▒▒▒▒████        ",
  "      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      ",
  "    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ",
  "  ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒      ",
  "  ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓  ",
  "  ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓  ",
  "██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██",
  "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
  "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
  "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
  "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██",
  "██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██",
  "████  ██▒▒██  ██▒▒▒▒██  ██▒▒██",
  "██      ██      ████      ████",
}
dashboard.section.header.val = {
  "                          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                             ",
  "                        ▓▓              ▓▓                           ",
  "                        ▓▓    ▒▒      ▒▒▓▓                           ",
  "                        ▓▓              ▓▓                           ",
  "                        ▓▓      ██████▓▓▓▓████                       ",
  "                        ▓▓    ▓▓▒▒░░░░░░░░░░░░██                     ",
  "                        ▓▓    ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                     ",
  "                      ██        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                       ",
  "                      ▓▓                  ▓▓                         ",
  "                    ██    ▓▓                ▓▓                       ",
  "                    ██    ▓▓                ▓▓                       ",
  "                    ██▓▓▓▓                  ▓▓                       ",
  "                    ██                      ▓▓                       ",
  "                      ▓▓                    ▓▓                       ",
  "                      ██      ████▓▓████████                         ",
  "                      ▒▒▒▒░░░░▓▓██▓▓▓▓▓▓▓▓██░░                       ",
  "                        ▓▓▒▒░░▓▓  ▓▓▒▒░░▓▓                           ",
  "                          ▓▓██      ██▓▓                             ",
  "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  "━━━━━━━━━━━━┏┓━━━━━━━━┏┓━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━",
  "━━━━━━━━━━━━┃┃━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━",
  "━━━━━━━━━━┏━┛┃┏┓┏┓┏━━┓┃┃┏┓━━━━┏━━┓┏━━┓┏┓┏┓┏┓┏━━┓┏━┓┏━━┓┏━┛┃━━━━━━━━━━",
  "━━━━━━━━━━┃┏┓┃┃┃┃┃┃┏━┛┃┗┛┛━━━━┃┏┓┃┃┏┓┃┃┗┛┗┛┃┃┏┓┃┃┏┛┃┏┓┃┃┏┓┃━━━━━━━━━━",
  "━━━━━━━━━━┃┗┛┃┃┗┛┃┃┗━┓┃┏┓┓━━━━┃┗┛┃┃┗┛┃┗┓┏┓┏┛┃┃━┫┃┃━┃┃━┫┃┗┛┃━━━━━━━━━━",
  "━━━━━━━━━━┗━━┛┗━━┛┗━━┛┗┛┗┛━━━━┃┏━┛┗━━┛━┗┛┗┛━┗━━┛┗┛━┗━━┛┗━━┛━━━━━━━━━━",
  "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
  "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",
}
dashboard.section.buttons.val = {
  dashboard.button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("SPC W r", " load last Worspace"),
  dashboard.button("SPC W l", " list Worspaces"),
  dashboard.button("SPC S r", " load last session"),
  dashboard.button("SPC S l", " list Sessions"),

  dashboard.button("q", "󰅚    > Quit NVIM", ":qa<CR>"),
}
dashboard.section.footer.val = footer

return dashboard.opts
