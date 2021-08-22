local Console = {}

setmetatable(Console, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

--- Create a new console writer
-- @params opts Optional parameters
-- @params opts.async Make the logger async, default: True
-- @params opts.processors The list of processors to chain the log entries in
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
    vim.api.nvim_echo(message, true, {})
  end

  if type(message) == "string" then
    message = { { message, nil } }
  end

  if not self.async and not vim.in_fast_event() then
    return impl()
  end

  vim.schedule(impl)
end

return Console
