return {
  size            = 10,
  open_mapping    = [[<c-\>]],
  shading_factor  = 2,
  shade_terminals = true,
  -- on_open         = function(t)
  --   t:send('cd ' .. vim.fn.getcwd())
  -- end,
  -- shell = vim.o.shell,
  direction       = "float",
  float_opts      = {
    border = "double",
    highlights = { border = "Normal", background = "Normal" },
  },
}
