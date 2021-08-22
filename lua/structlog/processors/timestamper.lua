--- Add a timestamp entry
-- @param format How to format the timestamp
local function Timestamper(format)
  return function(_, kwargs)
    kwargs["timestamp"] = os.date(format)
    return kwargs
  end
end

return Timestamper
