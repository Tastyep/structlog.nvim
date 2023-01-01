--- Entry point for loading processors.
-- A log processor is a regular callable, i.e a function or
-- an instance of a table with a __call() method.
--
-- Each log entry goes through a processor pipeline that is just a chain of functions
-- that receive a dictionary and return a new dictionary that gets fed into the next function.
-- That allows for simple but powerful data manipulation.
-- @module structlog.processors

--- Processor Module
-- @table M
-- @field Timestamper Add a 'timestamp' entry.
-- @field StackWriter Add entry in ['file', 'line'].
local M = {
  Timestamper = require("structlog.processors.timestamper"),
  StackWriter = require("structlog.processors.stack_writer"),
}

return M
