--- Format and Colorize log entries.

local FormatColorizer = {}

--- Format the log entries listed in entries and apply colorizers specified by colors.
-- Remaining entries will be written as key=value.
-- @function FormatColorizer
-- @param format A format to pass to string.format
-- @param entries The log entries to pass as arguments to string.format
-- @param colors A map of log entries to colorizer functions
setmetatable(FormatColorizer, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function FormatColorizer:new(format, entries, colors)
  return function(kwargs)
    local format_cpy = format

    local output = {}
    local consumed_events = { events = true }
    for _, entry in ipairs(entries) do
      local match = format_cpy:match("%%[^a-zA-Z]*[a-zA-Z]")
      local idx = format_cpy:find(match, 1, true)
      local plain = format_cpy:sub(1, idx - 1)
      format_cpy = format_cpy:sub(idx + match:len())
      table.insert(output, { plain, nil })

      local color = colors[entry] and colors[entry](kwargs[entry]) or nil
      table.insert(output, { match:format(kwargs[entry]), color })
      consumed_events[entry] = true
    end

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
      local color = colors.events and colors.events(events) or nil
      table.insert(output, { events:gsub(" = ", "="), color })
    end

    kwargs.msg = output
    return kwargs
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
