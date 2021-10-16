--- Write log entries to nvim-notify's notification manager.

--- The NvimNotify sink class.
-- @type NvimNotify
local NvimNotify = {}
local KeyValue = require("structlog.formatters.key_value")
local Level = require("structlog.level")

--- Create a writer for nvim-notify
-- @function NvimNotify
-- @param level The logging level of the sink
-- @param opts Optional parameters
-- @param opts.processors The list of processors to chain the log entries in
-- @param opts.formatter The formatter to format the log entries
-- @param opts.params_map The mapping between log entries and nvim-notify's parameters, default: {}
-- @usage opts.params_map = {title="logger_name", timeout="timeout"}
setmetatable(NvimNotify, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function NvimNotify:new(level, opts)
  opts = opts or {}

  local notify = {}

  local ok, impl = pcall(require, "notify")
  if not ok and not opts.impl then
    error("nvim-notify not found")
  end

  notify.level = level
  notify.impl = opts.impl or impl
  notify.processors = opts.processors or {}
  notify.formatter = opts.formatter or KeyValue()
  notify.params_map = opts.params_map or {}

  NvimNotify.__index = NvimNotify
  setmetatable(notify, NvimNotify)

  return notify
end

function NvimNotify:write(level, entry)
  local params = {}
  for name, key in pairs(self.params_map) do
    params[name] = entry[key]
  end
  self.impl(entry.msg, Level.name(level), params)
end

return NvimNotify
