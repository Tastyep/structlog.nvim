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

function Logger:log(level, msg, events)
  if level < self.level then
    return
  end

  local Level = require("structlog.level")
  local kwargs = {
    level = Level.name(level),
    msg = msg,
    events = events,
  }
  for _, sink in ipairs(self.sinks) do
    sink:write(kwargs)
  end
end

function Logger:trace(msg, events)
  self:log(self.level, msg, events)
end

function Logger:debug(msg, events)
  self:log(self.level, msg, events)
end

function Logger:info(msg, events)
  self:log(self.level, msg, events)
end

function Logger:warn(msg, events)
  self:log(self.level, msg, events)
end

function Logger:error(msg, events)
  self:log(self.level, msg, events)
end

return Logger
