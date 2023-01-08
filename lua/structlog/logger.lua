--- The logger package.

--- The logger class.
-- @type Logger
local Logger = {}

--- Create a new logger.
-- @function Logger
-- @param name The name of the logger.
-- @param pipelines The list of pipeline to write the log entries to.
-- @return A new logger instance.
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
  logger.context = { logger_name = name }

  Logger.__index = Logger
  setmetatable(logger, Logger)

  return logger
end

--- Create a copy of the current logger.
-- The context of the cloned logger is deepcopied from the original one.
-- @return A clone of the logger.
function Logger:clone()
  local logger = self:new(self.name, self.pipelines)
  logger.context = vim.deepcopy(self.context)

  return logger
end

--- Add a new pipeline to the logger.
-- @param pipeline The pipeline to add.
function Logger:add_pipeline(pipeline)
  table.insert(self.pipelines, pipeline)
end

--- Set the logger name and update it's context (logger_name).
-- @param name The name of the logger.
function Logger:set_name(name)
  self.name = name
  self.context.logger_name = name
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

--- Log a message and its events with a custom log level.
-- @param level The severity of the log.
-- @param msg The logging message.
-- @param events The list of key=value event pairs.
function Logger:log(level, msg, events)
  log(self, level, msg, events)
end

--- Log a message and its events in trace severity.
-- @see log
function Logger:trace(msg, events)
  log(self, Level.TRACE, msg, events)
end

--- Log a message and its events in debug severity.
-- @see log
function Logger:debug(msg, events)
  log(self, Level.DEBUG, msg, events)
end

--- Log a message and its events in info severity.
-- @see log
function Logger:info(msg, events)
  log(self, Level.INFO, msg, events)
end

--- Log a message and its events in warning severity.
-- @see log
function Logger:warn(msg, events)
  log(self, Level.WARN, msg, events)
end

--- Log a message and its events in error severity.
-- @see log
function Logger:error(msg, events)
  log(self, Level.ERROR, msg, events)
end

return Logger
