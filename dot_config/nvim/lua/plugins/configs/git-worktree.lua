return function()
  local Worktree = require("git-worktree")
  local Job = require("plenary.job")
  local utils = require("utils")

  local function copy_dotenv(from, to)
    -- vim.notify('[copy_dotenv] current path = ' .. vim.loop.cwd())
    -- vim.notify("copying dotenv from =" .. from .. " to =" .. to)
    if utils.file_exists(from .. "/" .. ".env") then
      vim.notify("copying dotenv from =" .. from .. " to =" .. to)
      Job:new({
        command = "cp",
        cwd = from,
        args = { ".env", "./" .. to },
        on_exit = function()
          -- print('[copy]' .. utils.dump(j))
          -- print('[copy_dotenv] value = ' .. value)
          vim.notify("dotenv copied")
        end,
      }):start()
    else
      vim.notify("[copy_dotenv] no dotenv found, skipped")
    end
  end

  local function npm_install(base, path)
    if utils.file_exists(base .. "/" .. path .. "/package.json") then
      vim.notify("start npm install=" .. path)
      -- print(utils.dump(os.getenv('PATH')))
      Job:new({
        command = "npm",
        -- args = { 'i' },
        cwd = base .. "/" .. path,
        on_exit = function(_, value)
          -- print('[ npm_install ]' .. utils.dump(j))
          vim.notify("[npm_install] value = " .. value)
          vim.notify("npm install done")
        end,
      }):start()
    else
      vim.notify("[npm_install] no package.json found, skipped")
    end
  end

  Worktree.on_tree_change(function(op, meta)
    -- op = Operations.Switch, Operations.Create, Operations.Delete
    -- metadata = table of useful values (structure dependent on op)
    --      Switch
    --          path = path you switched to
    --          prev_path = previous worktree path
    --      Create
    --          path = path where worktree created
    --          branch = branch name
    --          upstream = upstream remote name
    --      Delete
    --          path = path where worktree deleted
    -- vim.notify("[worktree]tree change:" .. utils.dump(meta))
    if op == Worktree.Operations.Create then
      Job:new({
        command = "git",
        args = { "rev-parse", "--path-format=absolute", "--git-common-dir" },
        on_stdout = function(_, bare_path)
          vim.notify("bare path = " .. bare_path .. "meta: " .. utils.dump(meta))
          -- copy_dotenv(meta.prev_path, meta.path)
          -- npm_install(meta.prev_path, meta.path)
        end,
      }):start()
    elseif op == Worktree.Operations.Switch then
      -- if utils.is_available('toggleterm.nvim') then
      -- print('worktree switch', meta.path)
      local terminals = vim.fn.filter(vim.api.nvim_list_chans(), function(_, chan)
        return chan["mode"] == "terminal" and chan["pty"] ~= ""
      end)
      vim.fn.map(terminals, function(_, value)
        vim.api.nvim_chan_send(value["id"], "cd " .. vim.fn.getcwd() .. "\n")
      end)
      -- end
    end
  end)
end
