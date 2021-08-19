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
  console.format = opts.format or function(...)
    return string.format("%-6s [%s] %s %s", ...)
  end
  console.processors = opts.processors or {}

  Console.__index = Console
  setmetatable(console, self)

  return console
end

function Console:write(kwargs)
  local function impl()
    for _, processor in ipairs(self.processors) do
      processor(kwargs)
    end

    local formatted_msg = vim.inspect(kwargs, { newline = "" })
    local ok = pcall(vim.cmd, string.format([[echom "%s"]], formatted_msg))
    if not ok then
      vim.api.nvim_out_write(formatted_msg .. "\n")
    end
  end

  if not self.async and not vim.in_fast_event() then
    impl()
    return
  end

  vim.schedule(impl)
end

return Console
