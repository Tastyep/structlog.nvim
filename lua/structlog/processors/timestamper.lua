--- Add a 'timestamp' entry to the log entries.

--- Add a timestamp entry.
-- @function Timestamper
-- @param format The format string passed to os.date.
--
--  Format examples can be found in these two links:
--
--  https://devdocs.io/lua~5.4/index#pdf-os.date
--
--  https://www.lua.org/pil/22.1.html
local function Timestamper(format)
  return function(_, kwargs)
    kwargs["timestamp"] = os.date(format)
    return kwargs
  end
end

return Timestamper
