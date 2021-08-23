--- Format log entries as key=value.

--- Format log entries as key=value.
-- @function KeyValue
local function KeyValue()
  return function(_, kwargs)
    return vim.inspect(kwargs, { newline = "", indent = " " })
  end
end

return KeyValue
