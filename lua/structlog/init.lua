--- Entry point for loading structlog modules.
-- @module structlog

--- StructLog Module
-- @table M
-- @field Logger The logger class.
-- @field Pipeline The logging pipeline class.
-- @field level The log levels.
-- @field formatters The log formatters.
-- @field processors The log processors.
-- @field sinks The log sinks.
local M = {
  Logger = require("structlog.logger"),
  Pipeline = require("structlog.pipeline"),

  level = require("structlog.level"),
  formatters = require("structlog.formatters"),
  processors = require("structlog.processors"),
  sinks = require("structlog.sinks"),
}

local loggers = {}

--- Configure loggers to be retrieved later using get_logger(...)
-- @usage configure({ logger_name = { pipelines = { { level, processors, formatter, sink }, { ... } }}})
-- @param logger_configs The loggers' configurations
function M.configure(logger_configs)
  local Pipeline = require("structlog.pipeline")

  for name, config in pairs(logger_configs) do
    local pipelines = {}

    for i, pipeline in ipairs(config.pipelines) do
      if pipeline["level"] ~= nil then
        pipelines[i] = Pipeline(pipeline.level, pipeline.processors, pipeline.formatter, pipeline.sink)
      else
        pipelines[i] = Pipeline(unpack(pipeline))
      end
    end
    loggers[name] = M.Logger(name, pipelines)
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
