local M = {
  Logger = require("structlog.logger"),

  level = require("structlog.level"),
  sinks = require("structlog.sinks"),
  processors = require("structlog.processors"),
}

return M
