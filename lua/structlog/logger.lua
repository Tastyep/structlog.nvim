--- The logger package.

--- The logger class.
-- @type Logger
local Logger = {}

--- Create a new logger.
-- @function Logger
-- @param name The name of the logger
-- @param pipelines The list of pipeline to write the log entries to
setmetatable(Logger, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

local Level = require("structlog.level")

function Logger:new(name, pipelines)
  local logger = {}

  logger.name = name
  logger.pipelines = pipelines
  logger.context = {}

  Logger.__index = Logger
  setmetatable(logger, Logger)

  return logger
end

function Logger:clone()
  local logger = self:new(self.name, self.pipelines)
  logger.context = vim.deepcopy(self.context)

  return logger
end

local function log(logger, level, msg, events)
  local log_entry = {
    level = Level.name(level),
    msg = msg,
    events = events or {},
  }
  for key, value in pairs(logger.context) do
    log_entry[key] = value
  end

  for _, pipeline in ipairs(logger.pipelines) do
    if level >= pipeline.level then
      local pipeline_log = vim.deepcopy(log_entry)

      pipeline:push(pipeline_log)
    end
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
