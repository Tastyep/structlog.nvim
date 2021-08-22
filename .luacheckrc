-- vim: ft=lua tw=80

stds.nvim = {
  globals = {
    "lvim",
    vim = { fields = { "g" } },
    os = { fields = { "capture" } },
  },
  read_globals = {
    "vim",
  },
}
std = "lua51+nvim"

-- Don't report unused self arguments of methods.
self = false

-- Rerun tests only if their modification time changed.
cache = true

ignore = {}
