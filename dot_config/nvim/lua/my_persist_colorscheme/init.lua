local utils = require("utils")
local M = {}

local setColorscheme = require("my_persist_colorscheme._persist")

M.setup = function()
  setColorscheme()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("set_colorscheme", { clear = true }),
    callback = function(args)
      -- print(utils.dump(args))
      local file = {
        "return function()",
        "vim.cmd [[colorscheme " .. args.match .. "]]",
        "end",
      }
      -- print(table.concat(file))
      vim.loop.fs_open(
        os.getenv("HOME") .. "/.config/nvim/lua/my_persist_colorscheme/_persist.lua",
        "w",
        432,
        function(err, fd)
          if err or fd == nil then
            vim.notify(utils.dump(err))
            return
          else
            vim.loop.fs_write(fd, table.concat(file, "\n"), 0, function()
              vim.loop.fs_close(fd)
            end)
          end
        end
      )
    end,
  })
end

return M
