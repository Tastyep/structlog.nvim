--- Add a formatted 'timestamp' entry to the log entries.
-- # The format specification can be found here:
-- <a href="https://www.lua.org/manual/5.4/manual.html#pdf-os.date">lua-5.4 manual</a>
-- and <a href="https://en.cppreference.com/w/c/chrono/strftime">cppreference: strftime</a>

--- Add a timestamp entry.
-- @function Timestamper
-- @param format The format string passed to os.date.
-- @return A callable function returning the updated log entry.
local function Timestamper(format)
  return function(log)
    log["timestamp"] = os.date(format)
    return log
  end
end

return Timestamper
