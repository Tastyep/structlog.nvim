--- Entry point for loading formatters.
-- StructlLog is completely flexible about how the resulting log entry is emitted.
-- Since each log entry is a dictionary, its message can be formatted to any format.
--
-- Internally, formatters are processors whose return value (a log entry with formatted message)
-- is passed into sinks that are responsible for the output of your message.
-- StructLog comes with multiple useful formatters out-of-the-box.
-- @module structlog.formatters

--- Formatter Module
-- @table M
-- @field Format Format log entries using a string format.
-- @field FormatColorizer Format and Colorize log entries.
-- Note that it is only available for the Console sink.
local M = {
  Format = require("structlog.formatters.format"),
  FormatColorizer = require("structlog.formatters.format_colorizer"),
  KeyValue = require("structlog.formatters.key_value"),
}

return M
