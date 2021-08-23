--- Add the logger name into log entries as 'logger_name'.

--- Add the logger name into log entries as 'logger_name'.
-- @function Namer
local function Namer()
  return function(logger, kwargs)
    kwargs["logger_name"] = logger.name
    return kwargs
  end
end

return Namer
