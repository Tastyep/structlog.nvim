local M = {
  Logger = require("structlog.logger"),

  level = require("structlog.level"),
  sinks = require("structlog.sinks"),
  processors = require("structlog.processors"),
  formatters = require("structlog.formatters"),
}

local loggers = {}

--- Configure loggers to be retrieved later using get_logger(...)
-- @usage configure({ logger_name = { level = log.level.INFO, sinks = { log.sinks.ConsoleSink(...), ... }}})
-- @params logger_configs The loggers' configurations
function M.configure(logger_configs)
  for name, config in pairs(logger_configs) do
    loggers[name] = M.Logger(name, config.level, config.sinks)
  end
end

--- Get a logger by name
-- @param name The name of the logger
-- @return A copy of the configured logger, nil if not found
function M.get_logger(name)
  local logger = loggers[name]
  if not logger then
    return nil
  end

  return logger:clone()
end

return M
