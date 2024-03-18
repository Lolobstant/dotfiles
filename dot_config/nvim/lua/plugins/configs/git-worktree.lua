return function(_, opts)
  local Worktree = require('git-worktree');
  local Job      = require('plenary.job');
  local utils    = require('utils')

  local function copy_dotenv(from, to)
    -- print('[copy_dotenv] current path = ' .. vim.loop.cwd())
    if utils.file_exists(from .. '/' .. '.env') then
      print('copying dotenv from =' .. from .. ' to =' .. to)
      Job:new({
        command = 'cp',
        cwd = from,
        args = { '.env', './' .. to },
        on_exit = function(_, value)
          -- print('[copy]' .. utils.dump(j))
          -- print('[copy_dotenv] value = ' .. value)
          print('dotenv copied')
        end
      }):start()
    else
      print('[copy_dotenv] no dotenv found, skipped')
    end
  end

  local function npm_install(base, path)
    if utils.file_exists(base .. '/' .. path .. '/package.json') then
      print('start npm install=' .. path)
      Job:new({
        command = 'yarn',
        cwd = base .. '/' .. path,
        on_exit = function(_, value)
          -- print('[ npm_install ]' .. utils.dump(j))
          print('[npm_install] value = ' .. value)
          print('npm install done')
        end
      }):start()
    else
      print('[npm_install] no package.json found, skipped')
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
    if op == Worktree.Operations.Create then
      Job:new({
        command = 'git',
        args = { 'rev-parse', '--path-format=absolute', '--git-common-dir' },
        on_stdout = function(_, bare_path)
          print('bare path = ' .. utils.dump(bare_path) .. ' worktree =' .. meta.path)
          copy_dotenv(bare_path, meta.path)
          npm_install(bare_path, meta.path)
        end
      }):start();
    end
    -- if op == Worktree.Operations.Switch then
    --   if utils.is_available('toggleterm.nvim') then
    --     local term = require('nvterm.terminal')
    --     term.send('cd ' .. meta.path, 'float')
    --   end
    -- end
  end)
end
