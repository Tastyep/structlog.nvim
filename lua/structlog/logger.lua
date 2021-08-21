local Logger = {}

setmetatable(Logger, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

local Level = require("structlog.level")

function Logger:new(name, level, sinks)
  local logger = {}

  logger.name = name
  logger.level = level
  logger.sinks = sinks

  Logger.__index = Logger
  setmetatable(logger, Logger)

  return logger
end

function Logger:clone()
  return self:new(self.name, self.level, self.sinks)
end

function Logger:log(level, msg, events)
  if level < self.level then
    return
  end

  local kwargs = {
    level = Level.name(level),
    msg = msg,
    events = events or {},
  }
  for _, sink in ipairs(self.sinks) do
    local sink_kwargs = vim.deepcopy(kwargs)

    for _, processor in ipairs(sink.processors) do
      sink_kwargs = processor(self, sink_kwargs)
    end
    if type(sink_kwargs) == "table" then
      sink_kwargs = vim.inspect(sink_kwargs, { newline = "", indent = " " })
    end

    print(sink_kwargs)
    sink:write(sink_kwargs)
  end
end

function Logger:trace(msg, events)
  self:log(Level.TRACE, msg, events)
end

function Logger:debug(msg, events)
  self:log(Level.DEBUG, msg, events)
end

function Logger:info(msg, events)
  self:log(Level.INFO, msg, events)
end

function Logger:warn(msg, events)
  self:log(Level.WARN, msg, events)
end

function Logger:error(msg, events)
  self:log(Level.ERROR, msg, events)
end

return Logger
