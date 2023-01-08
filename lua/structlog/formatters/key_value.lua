--- Format log entries as key=value.

--- Format log entries as key=value.
-- @function KeyValue
-- @return A callable that passes the log entry to vim.inspect.
local function KeyValue()
  return function(_, log)
    return vim.inspect(log, { newline = "", indent = " " })
  end
end

return KeyValue
