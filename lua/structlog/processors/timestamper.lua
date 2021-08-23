--- Add a 'timestamp' entry to the log entries.

--- Add a timestamp entry.
-- @function Timestamper
-- @param format How to format the timestamp
local function Timestamper(format)
  return function(_, kwargs)
    kwargs["timestamp"] = os.date(format)
    return kwargs
  end
end

return Timestamper
