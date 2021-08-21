vim.opt.display = "lastline" -- Avoid neovim/neovim#11362
vim.opt.directory = ""

local __file__ = debug.getinfo(1).source:match("@(.*)$")
local root_dir = vim.fn.fnamemodify(__file__, ":p:h:h")
local packpath = root_dir .. "/packpath/*"

vim.opt.runtimepath:append(root_dir)
vim.opt.runtimepath:append(packpath)

vim.cmd([[
  runtime! plugin/plenary.vim
]])
