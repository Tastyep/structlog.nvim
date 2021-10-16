--- Format entries using a string format.

--- Format the log entries listed in entries with the given format.
-- Remaining entries will be written as key=value.
-- @function Format
-- @param format A format to pass to string.format
-- @param entries The log entries to pass as arguments to string.format
-- @param opts Optional parameters
-- @param opts.blacklist A list of entries to not format, default: {}
local function Format(format, entries, opts)
  opts = opts or {}
  opts.blacklist = opts.blacklist or {}

  return function(kwargs)
    local format_args = {}

    local consumed_events = { events = true }
    for _, entry in ipairs(opts.blacklist) do
      consumed_events[entry] = true
    end
    for _, entry in ipairs(entries) do
      table.insert(format_args, kwargs[entry])
      consumed_events[entry] = true
    end
    kwargs.msg = string.format(format, unpack(format_args))

    -- Push remaining entries into events
    local events = vim.deepcopy(kwargs.events)
    for k, v in pairs(kwargs) do
      if not consumed_events[k] then
        events[k] = v
      end
    end

    if not vim.tbl_isempty(events) then
      events = vim.inspect(events, { newline = "", indent = " " }):sub(2, -2)
      -- TODO: Implement our own inspect to avoid modifying user message
      kwargs.msg = kwargs.msg .. events:gsub(" = ", "=")
    end

    return kwargs
  end
end

return Format
