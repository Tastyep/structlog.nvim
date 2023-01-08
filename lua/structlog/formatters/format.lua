--- Format entries using a string format.
-- The string format documentation can be found here:
-- <a href="https://www.lua.org/manual/5.4/manual.html#pdf-string.format">lua-5.4 manual</a>

--- Format the log entries listed in entries with the given format.
-- Remaining entries will be written as key=value.
-- @function Format
-- @param format A format to pass to string.format.
-- @param entries The log entries to pass as arguments to string.format.
-- @param opts Optional parameters.
-- @param opts.blacklist A list of entries to not format, default: {}.
-- @param opts.blacklist_all A boolean value indicating whether to format unformatted entries, default: false.
-- @return A callable that formats the log message in the given format.
local function Format(format, entries, opts)
  opts = opts or {}
  opts.blacklist = opts.blacklist or {}
  opts.blacklist_all = opts.blacklist_all == true

  return function(log)
    local format_args = {}

    local consumed_events = { events = true }
    for _, entry in ipairs(opts.blacklist) do
      consumed_events[entry] = true
    end
    for _, entry in ipairs(entries) do
      table.insert(format_args, log[entry])
      consumed_events[entry] = true
    end
    log.msg = string.format(format, unpack(format_args))

    if opts.blacklist_all then
      return log
    end

    -- Push remaining entries into events and format as key=value
    local events = vim.deepcopy(log.events)
    for k, v in pairs(log) do
      if not consumed_events[k] then
        events[k] = v
      end
    end

    if not vim.tbl_isempty(events) then
      events = vim.inspect(events, { newline = "", indent = " " }):sub(2, -2)
      -- TODO: Implement our own inspect to avoid modifying user message
      log.msg = log.msg .. events:gsub(" = ", "=")
    end

    return log
  end
end

return Format
