--- Entry point for loading sinks.
-- A sink is the final output of your logs entries.
-- Once they have been through the pipeline of log processors and formatter,
-- the final result is sent to the sink.
-- @module structlog.sinks

--- Sink Module
-- @table M
-- @field Console The class to write to nvim console.
-- @field File The class to write to a file.
-- @field RotatingFile The class to write to a rotating file.
-- @field Adapter The class to create custom sinks.
-- @field NvimNotify The class to write to nvim-notify notification manager.
local M = {
  Console = require("structlog.sinks.console"),
  File = require("structlog.sinks.file"),
  RotatingFile = require("structlog.sinks.rotating_file"),

  Adapter = require("structlog.sinks.adapter"),
  NvimNotify = require("structlog.sinks.plugins.nvim_notify"),
}

return M
