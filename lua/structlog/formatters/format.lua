--- Format entries using a string format.

--- Format the log entries listed in entries with the given format.
-- Remaining entries will be written as key=value.
-- @function Format
-- @param format A format to pass to string.format
-- @param entries The log entries to pass as arguments to string.format
local function Format(format, entries)
  return function(kwargs)
    local format_args = {}

    for _, entry in ipairs(entries) do
      table.insert(format_args, kwargs[entry])
      kwargs[entry] = nil
    end

    -- Push remaining entries into events
    for k, v in pairs(kwargs) do
      if k ~= "events" then
        kwargs.events[k] = v
      end
    end
    local output = string.format(format, unpack(format_args))

    if not vim.tbl_isempty(kwargs.events) then
      local events = vim.inspect(kwargs.events, { newline = "", indent = " " }):sub(2, -2)
      -- TODO: Implement our own inspect to avoid modifying user message
      output = output .. events:gsub(" = ", "=")
    end

    return output
  end
end

return Format
