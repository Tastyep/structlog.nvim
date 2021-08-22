--- Add the logger name into the 'logger_name' entry
local function Namer()
  return function(logger, kwargs)
    kwargs["logger_name"] = logger.name
    return kwargs
  end
end

return Namer
