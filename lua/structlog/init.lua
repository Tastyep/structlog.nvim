local M = {
  Logger = require("structlog.logger"),

  level = require("structlog.level"),
  sinks = require("structlog.sinks"),
  processors = require("structlog.processors"),
}

local loggers = {}

function M.configure(logger_configs)
  for name, config in pairs(logger_configs) do
    loggers[name] = M.Logger(name, config.level, config.processors)
  end
end

function M.get_logger(name)
  local logger = loggers[name]
  if not logger then
    return nil
  end

  return vim.deepcopy(logger)
end

return M
