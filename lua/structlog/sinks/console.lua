--- Write log entries to nvim's console.

--- The Console sink class.
-- @type Console
local Console = {}

--- Create a new console writer.
-- @function Console
-- @param async Make the logger async, default: True.
-- @return A new console sink instance.
setmetatable(Console, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Console:new(async)
  local console = {
    async = async,
  }

  Console.__index = Console
  setmetatable(console, Console)

  return console
end

function Console:write(entry)
  local message = entry.msg

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
