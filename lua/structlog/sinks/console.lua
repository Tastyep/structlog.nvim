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

function Console:write(kwargs)
  local function impl()
    if type(kwargs) == "table" then
      kwargs = vim.inspect(kwargs, { newline = "" })
    end

    local ok = pcall(vim.cmd, string.format([[echom "%s"]], kwargs))
    if not ok then
      vim.api.nvim_out_write(kwargs .. "\n")
    end
  end

  if not self.async and not vim.in_fast_event() then
    impl()
    return
  end

  vim.schedule(impl)
end

return Console
