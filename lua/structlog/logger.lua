local Logger = {}

setmetatable(Logger, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

local Level = require("structlog.level")

--- Create a new logger
-- @params name The name of the logger
-- @params level The logging level of the logger
-- @params sinks The list of sinks to write the log entries in
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

local function log(logger, level, msg, events)
  if level < logger.level then
    return
  end

  local kwargs = {
    level = Level.name(level),
    msg = msg,
    events = events or {},
  }
  for _, sink in ipairs(logger.sinks) do
    local sink_kwargs = vim.deepcopy(kwargs)

    for _, processor in ipairs(sink.processors) do
      sink_kwargs = processor(logger, sink_kwargs)
    end
    if type(sink_kwargs) == "table" then
      sink_kwargs = vim.inspect(sink_kwargs, { newline = "", indent = " " })
    end

    sink:write(sink_kwargs)
  end
end

function Logger:log(level, msg, events)
  log(self, level, msg, events)
end

function Logger:trace(msg, events)
  log(self, Level.TRACE, msg, events)
end

function Logger:debug(msg, events)
  log(self, Level.DEBUG, msg, events)
end

function Logger:info(msg, events)
  log(self, Level.INFO, msg, events)
end

function Logger:warn(msg, events)
  log(self, Level.WARN, msg, events)
end

function Logger:error(msg, events)
  log(self, Level.ERROR, msg, events)
end

return Logger
