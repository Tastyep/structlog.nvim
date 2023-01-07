--- Format log entries as key=value.

--- Format log entries as key=value.
-- @function KeyValue
local function KeyValue()
  return function(_, log)
    return vim.inspect(log, { newline = "", indent = " " })
  end
end

return KeyValue
