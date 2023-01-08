--- Format and Colorize log entries.

local FormatColorizer = {}

--- Format the log entries listed in entries and apply colorizers specified by colors.
-- Remaining entries will be written as key=value.
-- @function FormatColorizer
-- @param format A format to pass to string.format
-- @param entries The log entries to pass as arguments to string.format
-- @param colors A map of log entries to colorizer functions
-- @param opts Optional parameters
-- @param opts.blacklist A list of entries to not format, default: {}
-- @param opts.blacklist_all A boolean value indicating whether to format unformatted entries, default: false
-- @return A callable that formats the log message in the given format and colors.
setmetatable(FormatColorizer, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function FormatColorizer:new(format, entries, colors, opts)
  opts = opts or {}
  opts.blacklist = opts.blacklist or {}
  opts.blacklist_all = opts.blacklist_all == true

  return function(log)
    local format_cpy = format

    local output = {}
    local consumed_events = { events = true }
    for _, entry in ipairs(opts.blacklist) do
      consumed_events[entry] = true
    end
    for _, entry in ipairs(entries) do
      local match = format_cpy:match("%%[^a-zA-Z]*[a-zA-Z]")
      local idx = format_cpy:find(match, 1, true)

      if idx > 1 then
        local plain = format_cpy:sub(1, idx - 1)
        table.insert(output, { plain, nil })
      end
      format_cpy = format_cpy:sub(idx + match:len())

      local color = colors[entry] and colors[entry](log[entry]) or nil
      table.insert(output, { match:format(log[entry]), color })
      consumed_events[entry] = true
    end
    log.msg = output

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
      local color = colors.events and colors.events(events) or nil
      table.insert(log.msg, { events:gsub(" = ", "="), color })
    end

    return log
  end
end

--- Add color to the log level based on its value.
-- @function color_level
function FormatColorizer.color_level()
  local Level = require("structlog.level")
  local colors = {
    [Level.name(Level.TRACE)] = "Comment",
    [Level.name(Level.DEBUG)] = "Comment",
    [Level.name(Level.INFO)] = "None",
    [Level.name(Level.WARN)] = "WarningMsg",
    [Level.name(Level.ERROR)] = "ErrorMsg",
  }

  return function(level)
    return colors[level]
  end
end

--- Use the highlight group for the log entry
-- @function color
-- @param color The name of the highlight group
function FormatColorizer.color(color)
  return function(_)
    return color
  end
end

return FormatColorizer
