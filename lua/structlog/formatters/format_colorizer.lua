local FormatColorizer = {}

--- Add color to the log level based on its value
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
-- @param color The name of the highlight group
function FormatColorizer.color(color)
  return function(_)
    return color
  end
end

local function make_formatter(format, keys, colors)
  return function(kwargs)
    local format_cpy = format

    local output = {}
    for _, key in ipairs(keys) do
      local match = format_cpy:match("%%[^a-zA-Z]*[a-zA-Z]")
      local idx = format_cpy:find(match, 1, true)
      local plain = format_cpy:sub(1, idx - 1)
      format_cpy = format_cpy:sub(idx + match:len())
      table.insert(output, { plain, nil })

      local color = colors[key] and colors[key](kwargs[key]) or nil
      table.insert(output, { match:format(kwargs[key]), color })
      kwargs[key] = nil
    end

    -- Push remaining entries into events
    for k, v in pairs(kwargs) do
      if k ~= "events" then
        kwargs.events[k] = v
      end
    end
    if not vim.tbl_isempty(kwargs.events) then
      local events = vim.inspect(kwargs.events, { newline = "", indent = " " }):sub(2, -2)
      -- TODO: Implement our own inspect to avoid modifying user message
      local color = colors.events and colors.events(kwargs.events) or nil
      table.insert(output, { events:gsub(" = ", "="), color })
    end

    return output
  end
end

setmetatable(FormatColorizer, {
  __call = function(_, ...)
    return make_formatter(...)
  end,
})

return FormatColorizer
