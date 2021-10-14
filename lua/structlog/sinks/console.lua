--- Write log entries to nvim's console.

--- The Console sink class.
-- @type Console
local Console = {}
local KeyValue = require("structlog.formatters.key_value")

--- Create a new console writer
-- @function Console
-- @param level The logging level of the sink
-- @param opts Optional parameters
-- @param opts.async Make the logger async, default: True
-- @param opts.processors The list of processors to chain the log entries in
-- @param opts.formatter The formatter to format the log entries
setmetatable(Console, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Console:new(level, opts)
  opts = opts or {}

  local console = {}

  console.level = level
  console.async = opts.async or true
  console.processors = opts.processors or {}
  console.formatter = opts.formatter or KeyValue()

  Console.__index = Console
  setmetatable(console, Console)

  return console
end

function Console:write(_, message)
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
