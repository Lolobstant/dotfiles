local utils = require("utils")
local is_available = utils.is_available

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd -- AUTOSOURCE THEME

augroup("AutoCommands", { clear = true })

-- HIGHLIGHT YANKING TEXT
autocmd("TextYankPost", {
  group = "AutoCommands",
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

if is_available("mini.files") then
  local mini_files = require("mini.files")

  local files_set_cwd = function()
    local cur_entry_path = mini_files.get_fs_entry().path
    local cur_directory = vim.fs.dirname(cur_entry_path)
    vim.fn.chdir(cur_directory)
    print("path changed to " .. cur_directory)
  end

  autocmd("User", {
    group = "AutoCommands",
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      print("mini file set path")
      vim.keymap.set("n", ".", files_set_cwd, { buffer = args.data.buf_id, desc = "Set current directory" })
    end,
  })
end

-- autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
--  group = "AutoCommands",
--  pattern = "*",
--  desc = "Highlight trailing space",
--  callback = function()
--    vim.notify("highlight trailing")
--    vim.fn.matchadd("MiniTrailspace", [[\s\+$]])
--  end,
-- })
