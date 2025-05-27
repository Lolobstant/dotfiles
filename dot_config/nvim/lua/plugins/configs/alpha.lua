local dashboard = require("alpha.themes.dashboard")
local alpha = require("alpha")
local startup_time = nil

local function footer()
  local total_plugins = #vim.tbl_keys(require("lazy").plugins())
  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  local startup = not startup_time and "" or string.format("Loaded in %.oms", startup_time)

  return datetime .. "   " .. total_plugins .. " plugins " .. startup .. nvim_version_info
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("get_startuptime", {}),
  pattern = "LazyVimStarted",
  callback = function()
    startup_time = require("lazy").stats().startuptime
    vim.cmd.AlphaRedraw()
  end,
})

local function generateRandomBlocks(rows, cols)
  local result = {}
  -- local tab = { "◢", "◣", "◤", "◥" }
  local tab = { "⋐", "⋑", "⋒", "⋓" }
  for i = 1, rows do
    local line = ""
    for j = 1, cols do
      if math.random() < 0.5 then
        line = line .. tab[math.random(4)]
      else
        line = line .. "  "
      end
    end
    table.insert(result, line)
  end
  return result
end

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
local knowledge = [[
             ▄ ▄                   
         ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     
         █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     
      ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     
    ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  
    █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄
  ▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █
  █▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █
      █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    
Knowledge comes before speech and action
]]
local duck = [[
                            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                             
                          ▓▓              ▓▓                           
                          ▓▓    ▒▒      ▒▒▓▓                           
                          ▓▓              ▓▓                           
                          ▓▓      ██████▓▓▓▓████                       
                          ▓▓    ▓▓▒▒░░░░░░░░░░░░██                     
                          ▓▓    ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓                     
                        ██        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                       
                        ▓▓                  ▓▓                         
                      ██    ▓▓                ▓▓                       
                      ██    ▓▓                ▓▓                       
                      ██▓▓▓▓                  ▓▓                       
                      ██                      ▓▓                       
                        ▓▓                    ▓▓                       
                        ██      ████▓▓████████                         
                        ▒▒▒▒░░░░▓▓██▓▓▓▓▓▓▓▓██░░                       
                          ▓▓▒▒░░▓▓  ▓▓▒▒░░▓▓                           
                            ▓▓██      ██▓▓                             
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ━━━━━━━━━━━━┏┓━━━━━━━━┏┓━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┏┓━━━━━━━━━━
  ━━━━━━━━━━━━┃┃━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━
  ━━━━━━━━━━┏━┛┃┏┓┏┓┏━━┓┃┃┏┓━━━━┏━━┓┏━━┓┏┓┏┓┏┓┏━━┓┏━┓┏━━┓┏━┛┃━━━━━━━━━━
  ━━━━━━━━━━┃┏┓┃┃┃┃┃┃┏━┛┃┗┛┛━━━━┃┏┓┃┃┏┓┃┃┗┛┗┛┃┃┏┓┃┃┏┛┃┏┓┃┃┏┓┃━━━━━━━━━━
  ━━━━━━━━━━┃┗┛┃┃┗┛┃┃┗━┓┃┏┓┓━━━━┃┗┛┃┃┗┛┃┗┓┏┓┏┛┃┃━┫┃┃━┃┃━┫┃┗┛┃━━━━━━━━━━
  ━━━━━━━━━━┗━━┛┗━━┛┗━━┛┗┛┗┛━━━━┃┏━┛┗━━┛━┗┛┗┛━┗━━┛┗┛━┗━━┛┗━━┛━━━━━━━━━━
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┗┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
local rows = 15
local cols = 25

math.randomseed(os.time())
local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number" }
  return colors[math.random(#colors)]
end
local header = generateRandomBlocks(rows, cols)
table.insert(header, "Knowledge comes before speech and action")
dashboard.section.header.val = header
dashboard.section.header.opts.hl = pick_color()
-- dashboard.section.footer.val = "Knowledge comes before speech and action"
-- dashboard.section.header.val = knowledge
-- "https://github.com/aPeoplesCalendar/apc.nvim"
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
