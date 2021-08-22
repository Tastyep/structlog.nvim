local M = {
  Timestamper = require("structlog.processors.timestamper"),
  StackWriter = require("structlog.processors.stack_writer"),
  Namer = require("structlog.processors.namer"),
}

return M
