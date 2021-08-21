local Console = {}

setmetatable(Console, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Console:new(opts)
  opts = opts or {}

  local console = {}

  console.async = opts.async or true
  console.processors = opts.processors or {}

  Console.__index = Console
  setmetatable(console, self)

  return console
end

function Console:write(message)
  local function impl()
    local ok = pcall(vim.cmd, string.format([[echom "%s"]], message))
    if not ok then
      vim.api.nvim_out_write(message .. "\n")
    end
  end

  if not self.async and not vim.in_fast_event() then
    impl()
    return
  end

  vim.schedule(impl)
end

return Console
