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
    vim.notify("path changed to " .. cur_directory)
  end

  autocmd("User", {
    group = "AutoCommands",
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      -- vim.notify("mini file set path")
      vim.keymap.set("n", ".", files_set_cwd, { buffer = args.data.buf_id, desc = "Set current directory" })
    end,
  })
end

-- autocmd("FileType", {
--   pattern = "cmd",
--   callback = function()
--     local ui2 = require("vim._core.ui2")
--     vim.schedule(function()
--       local win = ui2.wins and ui2.wins.cmd
--       if win and vim.api.nvim_win_is_valid(win) then
--         local win_config = vim.api.nvim_win_get_config(win)
--         local width = win_config.width or math.floor(vim.o.columns * 0.6)
--         local height = win_config.height or 1
--         local row = 1 --(vim.o.lines - height) / 2
--         local col = (vim.o.columns - width) / 2
--         pcall(vim.api.nvim_win_set_config, win, {
--           relative = "editor",
--           row = row,
--           col = col,
--           width = width,
--           height = height,
--           anchor = "NW",
--           border = "rounded",
--           style = "minimal",
--         })
--       end
--     end)
--   end,
-- })

autocmd("LspProgress", {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp." .. ev.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

-- local ui2 = require("vim._core.ui2")
-- local msgs = require("vim._core.ui2.messages")
-- local orig_set_pos = msgs.set_pos
-- msgs.set_pos = function(tgt)
--   orig_set_pos(tgt)
--   if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
--     pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
--       relative = "editor",
--       anchor = "NE",
--       row = 1,
--       col = vim.o.columns - 1,
--       border = "rounded",
--     })
--   end
-- end

-- autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
--  group = "AutoCommands",
--  pattern = "*",
--  desc = "Highlight trailing space",
--  callback = function()
--    vim.notify("highlight trailing")
--    vim.fn.matchadd("MiniTrailspace", [[\s\+$]])
--  end,
-- })
