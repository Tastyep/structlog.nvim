local Logger = {}

setmetatable(Logger, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

function Logger:new(level, sinks)
  local logger = {}

  logger.level = level
  logger.sinks = sinks

  Logger.__index = Logger
  setmetatable(logger, Logger)

  return logger
end

function Logger:log(level, msg, kwargs)
  if level < self.level then
    return
  end

  local Level = require("structlog.level")
  kwargs.level = Level.name(level)
  kwargs.msg = msg
  for _, sink in ipairs(self.sinks) do
    sink:write(kwargs)
  end
end

function Logger:trace(msg, kwargs)
  self:log(self.level, msg, kwargs)
end

function Logger:debug(msg, kwargs)
  self:log(self.level, msg, kwargs)
end

function Logger:info(msg, kwargs)
  self:log(self.level, msg, kwargs)
end

function Logger:warn(msg, kwargs)
  self:log(self.level, msg, kwargs)
end

function Logger:error(msg, kwargs)
  self:log(self.level, msg, kwargs)
end

return Logger
