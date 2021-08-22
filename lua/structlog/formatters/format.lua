--- Format entries listed in keys with the given format
-- Remaining entries will written as key=value
-- @param format A format to pass to string.format
-- @param keys The keys to pass as arguments to string.format
local function Format(format, keys)
  return function(kwargs)
    local format_args = {}

    for _, key in ipairs(keys) do
      table.insert(format_args, kwargs[key])
      kwargs[key] = nil
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

local function FormatColorizer(format, keys, colors)
  return function(kwargs)
    local format_cpy = format

    local output = {}
    for _, key in ipairs(keys) do
      local match = format_cpy:match("%%[^a-zA-Z]*[a-zA-Z]")
      local idx = format_cpy:find(match, 1, true)
      local plain = format_cpy:sub(1, idx - 1)
      format_cpy = format_cpy:sub(idx + match:len())
      table.insert(output, { plain, nil })
      table.insert(output, { match:format(kwargs[key]), colors[key] })
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
      table.insert(output, { events:gsub(" = ", "="), colors.events })
    end

    return output
  end
end

return { Format = Format, FormatColorizer = FormatColorizer }
